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

  def realtime
    consumer_category&.name == "ICCS"
  end

  def initDates
    if realtime
      { duration: 1.week.to_i, start_date: nil, end_date: nil, type: "Real-time" }
    else
      start = (DateTime.now - 1.week).change(year: 2015)
      { start_date: start, end_date: start + 1.week, duration: nil, type: "Historical" }
    end
  end
end
