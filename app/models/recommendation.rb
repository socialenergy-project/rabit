class Recommendation < ApplicationRecord
  belongs_to :recommendation_type
  belongs_to :scenario

  enum status: [:created, :sent, :notified]

  has_and_belongs_to_many :consumers

  def messages
    consumers.map do |c|
      recommendation_type.description % [c.name, parameter]
    end
  end
end
