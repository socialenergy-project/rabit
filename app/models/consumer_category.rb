class ConsumerCategory < ApplicationRecord
  has_many :consumers, dependent: :restrict_with_error
end
