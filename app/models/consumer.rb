class Consumer < ApplicationRecord
  belongs_to :building_type, optional: true
  belongs_to :connection_type, optional: true
  belongs_to :consumer_category
  has_and_belongs_to_many :communities
  has_many :data_points, dependent: :destroy

  scope :category, ->(cat) { where(consumer_category: cat) if cat.present? }
end
