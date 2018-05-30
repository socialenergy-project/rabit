require 'fetch_data/fetch_data'

class Consumer < ApplicationRecord
  belongs_to :building_type, optional: true
  belongs_to :connection_type, optional: true
  belongs_to :consumer_category
  has_and_belongs_to_many :communities
  has_and_belongs_to_many :users
  has_and_belongs_to_many :recommendations
  has_many :data_points, dependent: :destroy

  scope :category, ->(cat) { where(consumer_category: cat) if cat.present? }
  scope :with_locations, -> { where("location_x IS NOT NULL and location_y IS NOT NULL") }


  validates_associated :communities, message: ->(_class_obj, obj){ p "consumer OBJ is ", obj[:value]; obj[:value].map(&:errors).map(&:full_messages).join(',') }

  def initDates
    start = DateTime.now - 1.week
    if consumer_category&.name == "ICCS"
      start += 3.hours
    else
      start = start.change(year: 2015)
    end
    { start: start, end: start + 1.week }
  end
end
