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

  def getData(chart_cookies)

    FetchData::FetchData.new([self], chart_cookies).sync
    {
        '0': data_points.joins(:consumer).where(timestamp: chart_cookies[:start_date] .. chart_cookies[:end_date],
                                       interval_id: chart_cookies[:interval_id])
                 .group('consumers.name')
                 .select('consumers.name as con',
                         'array_agg(timestamp ORDER BY data_points.timestamp asc) as tims',
                         'array_agg(consumption ORDER BY data_points.timestamp ASC) as cons')
                 .map{|d| [d.con, d.tims.zip(d.cons)] }.to_h
    }
  end

  def initDates
    start = DateTime.now - 1.week
    if consumer_category&.name == "CTI"
      start += 3.hours
    else
      start = start.change(year: 2015)
    end
    { start: start, end: start + 1.week }
  end
end
