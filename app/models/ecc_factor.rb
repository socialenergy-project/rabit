class EccFactor < ApplicationRecord
  belongs_to :ecc_term
  after_destroy :destroy_orphaned_terms

  enum period: [
      :hourly_per_minute,
      :daily_per_15_min,
      :daily_per_hour,
      :weekly_per_day,
      :monthly_per_day,
      :yearly_per_month,
  ]

  validates_presence_of :period

  def get_valid_timestamps(timestamps)
    timestamps.select do |t|
      value = case period
      when "hourly_per_minute"
        t.minute
      when "daily_per_15_min"
        t.hour * 4
      when "daily_per_hour"
        t.hour
      when "weekly_per_day"
        t.wday
      when "monthly_per_day"
        t.day
      when "yearly_per_month"
        t.month
      else
        raise "Wrong period"
      end
      between(value, start, stop)
    end
  end

  private

  def destroy_orphaned_terms
    ecc_term.delete if ecc_term&.ecc_factors&.count == 0
  end

  def between(value, low, high)
    return false if low and value < low
    return false if high and value > high
    true
  end

end
