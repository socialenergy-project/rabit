class Consumer < ApplicationRecord
  belongs_to :building_type, optional: true
  belongs_to :connection_type, optional: true
  belongs_to :consumer_category
  has_and_belongs_to_many :communities

  scope :category, ->(cat) { where(consumer_category: cat) if cat.present? }
end
