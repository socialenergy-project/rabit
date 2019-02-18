class LcmsScore < ApplicationRecord
  belongs_to :user

  def self.get_current_score(user_id)
    LcmsScore.where(user_id: user_id)
             .group(:competence)
             .maximum(:current_score)
             .values
             .sum
  end

  def self.get_last_week_score(user_id)
    LcmsScore.where(user_id: user_id)
             .group(:competence)
             .maximum(:last_week_score)
             .values
             .sum
  end

  def self.get_last_month_score(user_id)
    LcmsScore.where(user_id: user_id)
             .group(:competence)
             .maximum(:last_month_score)
             .values
             .sum
  end

  def self.get_current_score_competence(user_id, competence)
    LcmsScore.where(user_id: user_id, competence: competence)
             .maximum(:current_score)
  end
end
