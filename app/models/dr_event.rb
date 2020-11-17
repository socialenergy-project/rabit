# frozen_string_literal: true

class DrEvent < ApplicationRecord
  belongs_to :interval
  belongs_to :consumer_category, optional: true

  has_many :dr_targets, dependent: :destroy

  enum state: %i[created ready active in_progress completed elapsed]
  enum dr_type: %i[automatic manual]

  accepts_nested_attributes_for :dr_targets,
                                allow_destroy: true,
                                reject_if: ->(attr) { attr['volume'].blank? }

  def schedule!
    sla_avalability_vector = dr_targets.map do |drt|
      [drt, (slas_for_ts(drt.timestamp_start) & slas_for_ts(drt.timestamp_stop))]
    end.to_h

    result = dr_targets.map do |target|
      ts_plan = []
      vol = 0
      ts_allocation = {}
      completed = false
      sla_avalability_vector[target].sort_by(&:price_per_mw).each do |sla|
        puts 'The allocation is ', ts_allocation
        remaining_vol = target.volume - vol
        completed = remaining_vol <= 0

        ts_allocation[sla.ecc_type.consumer] ||= begin
          DrAction.for_timestamp_range(target.timestamp_start,
                                       target.timestamp_stop)
                  .where(consumer_id: sla.ecc_type.consumer_id)
                  .sum :volume_planned
        end

        next unless (sla.value - ts_allocation[sla.ecc_type.consumer]).positive?
        break if completed

        puts 'remaining_vol=', remaining_vol, 'sla.value=', sla.value, 'ts_allocation[sla.ecc_type.consumer]=', ts_allocation[sla.ecc_type.consumer]

        vol_to_add = remaining_vol > sla.value - ts_allocation[sla.ecc_type.consumer] ? sla.value - ts_allocation[sla.ecc_type.consumer] : remaining_vol
        ts_allocation[sla.ecc_type.consumer] += vol_to_add
        ts_plan << { consumer: sla.ecc_type.consumer, volume: vol_to_add, price_per_mw: sla.price_per_mw }
        vol += vol_to_add
      end
      [target, { ts_plan: ts_plan, completed: completed }]
    end.to_h

    dr_targets.map(&:dr_plan_actions).map(&:destroy_all)

    DrPlanAction.insert_all!(
      result.map do |target, plan|
        plan[:ts_plan].map do |act|
          {
            dr_target_id: target.id,
            consumer_id: act[:consumer].id,
            volume_planned: act[:volume],
            price_per_mw: act[:price_per_mw],
            created_at: DateTime.now,
            updated_at: DateTime.now
          }
        end
      end.flatten
    )
    self.state = :ready
    save!
  end

  def slas_for_ts(timestamp)
    res = EccTerm.joins(ecc_type: :consumer)
                 .includes(ecc_type: :consumer)
                 .where('consumer_id IS NOT NULL')
    res = res.where('consumers.consumer_category_id': consumer_category_id) unless consumer_category_id.blank?
    res.select { |e| e.get_sla_for_ts(timestamp) }
  end

  def activate!
    return false if dr_targets.any? { |t| t.dr_actions.count.positive? }

    self.state = :active
    save!

    DrAction.insert_all(
      dr_targets.map do |target|
        target.dr_plan_actions.map do |act|
          {
            dr_target_id: target.id,
            consumer_id: act.consumer_id,
            volume_planned: act.volume_planned,
            price_per_mw: act.price_per_mw,
            created_at: DateTime.now,
            updated_at: DateTime.now
          }
        end
      end.flatten
    )
  end

  def cancel!
    return false unless active?

    DrAction.joins(:dr_target).where('dr_targets.dr_event': self).delete_all

    self.state = :ready
    save!
  end
end
