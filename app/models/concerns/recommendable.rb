module Recommendable
  extend ActiveSupport::Concern

  included do
    has_many :recommendations, dependent: :restrict_with_exception, as: :recommendable
    validate :dont_change_when_there_are_recommendations
  end

  private

  def dont_change_when_there_are_recommendations
    if recommendations.count > 0
      errors.add(:recommendable_id, "Cannot modify recommendable with active recommendations")
    end
  end
end