class EccType < ApplicationRecord
  has_many :scenarios, dependent: :nullify

  has_many :ecc_terms, dependent: :destroy

  accepts_nested_attributes_for :ecc_terms,
                                allow_destroy: true,
                                reject_if: :all_empty

  belongs_to :consumer

  def get_valid_timestamps(timestamps)
    ecc_terms.sum do |ecc_term|
      ecc_term.get_valid_timestamps(timestamps)
    end.flatten.sort.uniq
  end

  def get_sla(timestamps)
    ecc_terms.map do |ecc_term|
      ecc_term.get_sla(timestamps)
    end
  end


  def realtime?
    false
  end

  def reference_year
    2015
  end

  def initDates
    start_time = (DateTime.now - 1.week)
    start_time = (start_time.change(year: 2015) rescue (start_time-1.day).change(year: 2015))
    {
        start_date: start_time,
        end_date: start_time + 1.week,
        duration: nil,
        type: "Historical",
        interval_id: Interval.find_by(duration: 3600).id,
    }
  end

  private

  def all_empty(attributes)
    ! attributes[:ecc_factors_attributes]&.any? {|k1,v1| v1.any? {|k2,v2| ! v2.blank? }}
  end

end
