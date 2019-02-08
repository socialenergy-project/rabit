class GameActivity < ApplicationRecord
  belongs_to :user


  def self.get_current_score(user_id)
     GameActivity.where(user_id: user_id).maximum(:totalScore)
  end

  def self.get_total_time_played(user_id)
    GameActivity.where(user_id: user_id).sum(:gameDuration)
  end
end
