class DrEvent < ApplicationRecord
  belongs_to :interval
  has_many :dr_targets, dependent: :destroy

  enum state: %i[created ready active completed elapsed]
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
        puts "The allocation is ", ts_allocation
        remaining_vol = target.volume - vol
        completed = remaining_vol <= 0
        break if completed

        ts_allocation[sla.ecc_type.consumer] ||= 0
        puts "remaining_vol=", remaining_vol, "sla.value=", sla.value,  "ts_allocation[sla.ecc_type.consumer]=", ts_allocation[sla.ecc_type.consumer]

        vol_to_add = (remaining_vol > sla.value - ts_allocation[sla.ecc_type.consumer]) ? sla.value - ts_allocation[sla.ecc_type.consumer] : remaining_vol
        ts_allocation[sla.ecc_type.consumer] += vol_to_add
        ts_plan << { consumer: sla.ecc_type.consumer, volume: vol_to_add, price_per_mw: sla.price_per_mw }
        vol += vol_to_add
      end
      [target, {ts_plan: ts_plan, completed: completed}]
    end.to_h

    dr_targets.map(&:dr_plan_actions).map(&:destroy_all)

    DrPlanAction.insert_all(
      result.map do |target, plan|
        plan[:ts_plan].map do |act|
          {
            dr_target_id: target.id,
            consumer_id: act[:consumer].id,
            volume_planned: act[:volume],
            price_per_mw: act[:price_per_mw],
            created_at: DateTime.now,
            updated_at: DateTime.now,
          }
        end
      end.flatten
    )

  end

  def slas_for_ts(timestamp)
    EccTerm.joins(:ecc_type)
           .includes(ecc_type: :consumer)
           .where('consumer_id IS NOT NULL')
           .select{|e| e.get_sla_for_ts(timestamp)}
  end



end
