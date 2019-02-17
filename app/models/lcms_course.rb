class LcmsCourse < ApplicationRecord
  belongs_to :user

  def self.get_total_time_played(user_id)
    LcmsCourse.where(user_id: user_id).sum(:time_spent_seconds)
  end
end
