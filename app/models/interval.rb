class Interval < ApplicationRecord
  has_many :data_points, dependent: :nullify
  has_many :scenarios, dependent: :nullify
  has_many :cl_scenarios, dependent: :nullify

  def next_timestamp(datetime)
    Time.at((datetime.to_f / self.duration).ceil * self.duration).to_datetime
  end

  def previous_timestamp(datetime)
    Time.at((datetime.to_f / self.duration).floor * self.duration).to_datetime
  end

  def timestamps(start_date_time, end_date_time)
    next_timestamp(start_date_time).step(previous_timestamp(end_date_time), 1.to_f/60/60/24 * duration)
  end
end
