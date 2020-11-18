class ConsumerCategory < ApplicationRecord
  has_many :consumers, dependent: :restrict_with_error
  has_many :dr_plan_actions, dependent: :restrict_with_error
end
