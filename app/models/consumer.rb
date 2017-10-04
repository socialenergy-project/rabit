class Consumer < ApplicationRecord
  belongs_to :building_type, optional: true
  belongs_to :connection_type, optional: true
  belongs_to :consumer_category
  has_and_belongs_to_many :communities
end
