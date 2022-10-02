# frozen_string_literal: true

class DrEvent < ApplicationRecord
  belongs_to :interval
  belongs_to :consumer_category, optional: true

  has_many :dr_targets, dependent: :destroy

  enum state: %i[created ready active in_progress completed elapsed]
  enum dr_type: %i[automatic manual]

  accepts_nested_attributes_for :dr_targets,
                                allow_destroy: true,
                                reject_if: ->(attr) { attr["volume"].blank? }

  validates_presence_of :name

  validates_presence_of :starttime

  validate :valid_starttime

  validates_presence_of :consumer_category

  validates_presence_of :price

  validates_presence_of :dr_targets

  validates_presence_of :dr_type

  validate :continuous_ts_offsets

  def valid_starttime
    errors.add(:starttime, "is not a multiple of the interval (#{interval.duration} sec)") unless starttime.to_i % interval.duration == 0
    errors.add(:starttime, "is not in the future") unless starttime > DateTime.now
  end

  def continuous_ts_offsets
    dr_targets.order(ts_offset: :asc).each_with_index do |dr_target, i|
      if i != dr_target.ts_offset
        errors.add(:'dr_targets.ts_offset', "offsets must start at zero and be consequtive")
        return
      end
    end
  end

  def create_and_possibly_activate
    ActiveRecord::Base.transaction do
      save
      if dr_type == "automatic"
        return schedule! && activate!
      end
    end
    return self
  rescue Exception => e
    errors.add(:'create_and_possibly_activate', "#{e} #{e.backtrace}")

    return false
  end

  def schedule!
    return false if self.state == :active

    ActiveRecord::Base.transaction do
      result_groups = consumer_category_id.blank? ? (categories + [ConsumerCategory.where(name: ["DR low voltage", "DR medium voltage"])]) : categories
      sla_avalability_vector = result_groups.map do |cat|
        [cat, dr_targets.map do |drt|
          [drt, (slas_for_ts(drt.timestamp_start, cat) & slas_for_ts(drt.timestamp_stop, cat))]
        end.to_h]
      end.to_h

      result = sla_avalability_vector.map do |cat, _v|
        [cat, dr_targets.map do |target|
          ts_plan = []
          vol = 0
          ts_allocation = {}
          completed = false
          sla_avalability_vector[cat][target].sort_by(&:price_per_mw).each do |sla|
            puts "The allocation is ", ts_allocation
            remaining_vol = target.volume - vol
            completed = remaining_vol <= 0

            ts_allocation[sla.ecc_type.consumer] ||= begin
                DrAction.for_timestamp_range(target.timestamp_start,
                                             target.timestamp_stop)
                        .where(consumer_id: sla.ecc_type.consumer_id).sum :volume_planned
              end

            next unless (sla.value - ts_allocation[sla.ecc_type.consumer]).positive?
            break if completed

            puts "remaining_vol=", remaining_vol, "sla.value=", sla.value, "ts_allocation[sla.ecc_type.consumer]=", ts_allocation[sla.ecc_type.consumer]

            vol_to_add = remaining_vol > sla.value - ts_allocation[sla.ecc_type.consumer] ? sla.value - ts_allocation[sla.ecc_type.consumer] : remaining_vol
            ts_allocation[sla.ecc_type.consumer] += vol_to_add
            ts_plan << { consumer: sla.ecc_type.consumer, volume: vol_to_add, price_per_mw: sla.price_per_mw }
            vol += vol_to_add
          end
          [target, { ts_plan: ts_plan, completed: completed }]
        end.to_h]
      end.to_h
      dr_targets.map(&:dr_plan_actions).map(&:destroy_all)

      DrPlanAction.insert_all!(
        result.map do |cat, cat_plan|
          cat_plan.map do |target, plan|
            puts "The result is", JSON.pretty_generate(result), target, plan

            target.update!(cleared_price: plan[:ts_plan].max { |act| act[:price_per_mw] }[:price_per_mw])
            plan[:ts_plan].map do |act|
              {
                dr_target_id: target.id,
                consumer_id: act[:consumer].id,
                volume_planned: act[:volume],
                price_per_mw: act[:price_per_mw],
                consumer_category_id: (cat.is_a?(ConsumerCategory) ? cat.id : nil),
                created_at: DateTime.now,
                updated_at: DateTime.now,
              }
            end
          end.flatten
        end.flatten
      )
      self.state = :ready
      save!
      self.reload
    end
  rescue Exception => e
    errors.add(:'schedule', "Schedule has failed #{e} #{e.backtrace}")
    return false
  end

  def categories
    consumer_category_id ? [consumer_category] : ConsumerCategory.where(name: ["DR low voltage", "DR medium voltage"])
  end

  def slas_for_ts(timestamp, cat = categories)
    res = EccTerm.joins(ecc_type: :consumer)
                 .includes(ecc_type: :consumer)
                 .where("consumer_id IS NOT NULL")
                 .where('consumers.consumer_category_id': cat)
                 .select { |e| e.get_sla_for_ts(timestamp) }
  end

  def activate!
    return false if dr_targets.any? { |t| t.dr_actions.count.positive? }

    return false unless self.state = :ready
    ActiveRecord::Base.transaction do
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
              updated_at: DateTime.now,
            }
          end
        end.flatten
      )
    end
  rescue Exception => e
    errors.add(:'activate', "activate has failed #{e}  #{e.backtrace}")
    return false
  end

  def cancel!
    # return false unless active?
    ActiveRecord::Base.transaction do
      DrAction.joins(:dr_target).where('dr_targets.dr_event': self).delete_all

      self.state = :ready
      save!
    end
  rescue
    return false
  end
end
