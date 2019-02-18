class GameReward < ApplicationRecord
  belongs_to :user

  def self.get_current_gredits(user_id)
    GameReward.where(user_id: user_id).order(updated_at: :desc)&.first&.total_credits
  end

  def self.get_cash(user_id)
    GameReward.where(user_id: user_id).order(updated_at: :desc)&.first&.total_cash
  end

  def self.get_ex_points(user_id)
    GameReward.where(user_id: user_id).order(updated_at: :desc)&.first&.total_ex_points
  end
end
