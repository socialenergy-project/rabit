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
  scope :with_locations, -> { where('location_x IS NOT NULL and location_y IS NOT NULL') }

  #   validates_associated :communities, message: ->(_class_obj, obj) {
  #     p "consumer OBJ is #{_class_obj} #{obj}", obj[:value]; obj[:value].map(&:errors).map(&:full_messages).join(',')
  #   }

  def realtime?
    reference_year.nil?
  end

  def reference_year
    consumer_category.reference_year
  end

  def initDates
    if realtime?
      { duration: 1.week.to_i, start_date: nil, end_date: nil, type: 'Real-time' }
    else
      start = (DateTime.now - 1.week)
      start = (begin
                 start.change(year: consumer_category.reference_year)
               rescue StandardError
                 (start - 1.day).change(year: consumer_category.reference_year)
               end)
      { start_date: start, end_date: start + 1.week, duration: nil, type: 'Historical' }
    end.merge interval_id: Interval.find_by(duration: 3600).id
  end

  def self.import(consumers, category)
    Consumer.bulk_insert ignore: true, values: (consumers.map do |c|
      {
        name: "Flexgrid - #{c['_id']}",
        edms_id: c['_id'],
        consumer_category_id: category,
      }
    end)
    Community.find(12).consumers = Consumer.where consumer_category_id: category
  end
end
