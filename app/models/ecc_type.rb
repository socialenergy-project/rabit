class EccType < ApplicationRecord
  has_many :scenarios, dependent: :nullify
end
