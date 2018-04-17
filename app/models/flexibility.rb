class Flexibility < ApplicationRecord
  has_many :scenarios, dependent: :nullify
  has_many :cl_scenarios, dependent: :nullify
end
