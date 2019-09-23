require 'fetch_data/fetch_data'

class Consumer < ApplicationRecord
  belongs_to :building_type, optional: true
  belongs_to :connection_type, optional: true
  belongs_to :consumer_category
  belongs_to :energy_program, optional: true
  has_and_belongs_to_many :communities
  has_and_belongs_to_many :users
  has_and_belongs_to_many :recommendations
  has_many :data_points, dependent: :destroy
  has_many :smart_plugs, dependent: :destroy

  scope :category, ->(cat) { where(consumer_category: cat) if cat.present? }
  scope :with_locations, -> { where("location_x IS NOT NULL and location_y IS NOT NULL") }


=begin
  validates_associated :communities, message: ->(_class_obj, obj) {
    p "consumer OBJ is #{_class_obj} #{obj}", obj[:value]; obj[:value].map(&:errors).map(&:full_messages).join(',')
  }
=end

  def realtime?
    ["ICCS", "Emulated"].include? consumer_category&.name
  end

  def initDates
    if realtime?
      { duration: 1.week.to_i, start_date: nil, end_date: nil, type: "Real-time" }
    else
      start = (DateTime.now - 1.week).change(year: 2015)
      { start_date: start, end_date: start + 1.week, duration: nil, type: "Historical" }
    end.merge interval_id: Interval.find_by(duration: 3600).id
  end
end
