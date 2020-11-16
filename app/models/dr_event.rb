class DrEvent < ApplicationRecord
  belongs_to :interval
  has_many :dr_targets, dependent: :destroy

  enum state: %i[created ready active completed elapsed]
  enum dr_type: %i[automatic manual]

  accepts_nested_attributes_for :dr_targets,
                                allow_destroy: true,
                                reject_if: ->(attr) { attr['volume'].blank? }


  def schedule
    sla_avalability_vector = dr_targets.map do |drt|
      [drt, (slas_for_ts(drt.timestamp_start) & slas_for_ts(drt.timestamp_stop))]
    end.to_h

    dr_targets.map do |target|
      ts_plan = []
      vol = 0
      ts_allocation = {}
      completed = false
      sla_avalability_vector[target].sort(&:price_per_mw).each do |sla|
        remaining_vol = target.volume - vol
        completed = remaining_vol <= 0
        break if completed

        ts_allocation[:consumer] ||= 0
        vol_to_add = (remaining_vol > sla.value - ts_allocation[:consumer]) ? sla.value : remaining_vol
        ts_allocation[:consumer] += vol_to_add
        ts_plan << { consumer: sla.ecc_type.consumer, volume: vol_to_add, price_per_mw: sla.price_per_mw }
        vol += vol_to_add
      end
      [target, {plan: ts_plan, completed: completed}]
    end.to_h

  end

  def slas_for_ts(timestamp)
    EccTerm.joins(:ecc_type)
           .includes(ecc_type: :consumer)
           .where('consumer_id IS NOT NULL')
           .select{|e| e.get_sla_for_ts(timestamp)}
  end



end
