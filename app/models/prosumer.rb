class Prosumer < ApplicationRecord
  belongs_to :building_type, optional: true
  belongs_to :connection_type, optional: true
  belongs_to :prosumer_category, optional: true
  has_and_belongs_to_many :clusters
end
