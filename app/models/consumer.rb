class Consumer < ApplicationRecord
  belongs_to :building_type, optional: true
  belongs_to :connection_type, optional: true
  belongs_to :consumer_category
  has_and_belongs_to_many :communities
  has_many :data_points, dependent: :destroy

  scope :category, ->(cat) { where(consumer_category: cat) if cat.present? }

  validates_associated :communities, message: ->(_class_obj, obj){ p "consumer OBJ is ", obj[:value]; obj[:value].map(&:errors).map(&:full_messages).join(',') }
end
