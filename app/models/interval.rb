class Interval < ApplicationRecord
  has_many :data_points, dependent: :nullify
end
