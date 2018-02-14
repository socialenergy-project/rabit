class Recommendation < ApplicationRecord
  belongs_to :recommendation_type
  belongs_to :scenario

  enum status: [:created, :sent, :notified]
end
