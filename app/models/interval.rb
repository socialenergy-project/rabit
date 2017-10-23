class Interval < ApplicationRecord
  has_many :data_points, dependent: :nullify
  has_many :scenarios, dependent: :nullify
end
