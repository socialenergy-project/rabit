class EccFactor < ApplicationRecord
  belongs_to :ecc_term
  after_destroy :destroy_orphaned_terms

  enum period: %i[
    hourly_per_minute
    daily_per_15_min
    daily_per_hour
    weekly_per_day
    monthly_per_day
    yearly_per_month
  ]

  validates_presence_of :period

  def is_valid_ts?(timestamp)
    value = case period
            when 'hourly_per_minute'
              timestamp.minute
            when 'daily_per_15_min'
              timestamp.hour * 4
            when 'daily_per_hour'
              timestamp.hour
            when 'weekly_per_day'
              timestamp.wday
            when 'monthly_per_day'
              timestamp.day
            when 'yearly_per_month'
              timestamp.month
            else
              raise 'Wrong period'
            end
    between(value, start, stop)
  end

  def get_valid_timestamps(timestamps)
    timestamps.select do |t|
      is_valid_ts? t
    end
  end

  private

  def destroy_orphaned_terms
    ecc_term.delete if ecc_term&.ecc_factors&.count == 0
  end

  def between(value, low, high)
    return false if low && (value < low)
    return false if high && (value > high)

    true
  end
end
