class Clustering < ApplicationRecord
  has_many :communities, dependent: :destroy
end
