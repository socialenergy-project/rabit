class RecommendationType < ApplicationRecord
  has_many :recommendations, dependent: :nullify
end
