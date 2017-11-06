class Flexibility < ApplicationRecord
  has_many :scenarios, dependent: :nullify
end
