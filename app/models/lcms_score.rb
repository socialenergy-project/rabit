class LcmsScore < ApplicationRecord
  belongs_to :user

  def self.get_current_score(user_id)
    LcmsScore.where(user_id: user_id)
             .group(:competence)
             .maximum(:current_score)
             .values
             .sum
  end
end
