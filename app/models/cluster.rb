class Cluster < ApplicationRecord
  belongs_to :clustering
  has_and_belongs_to_many :prosumers
end
