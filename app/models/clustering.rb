class Clustering < ApplicationRecord
  has_many :communities, dependent: :destroy

  validates_associated :communities, message: ->(_class_obj, obj){ p "community OBJ is ", obj[:value]; obj[:value].map(&:errors).map(&:full_messages).join(',') }

  has_one :cl_scenario, dependent: :nullify

  def get_icon_index(prosumer)
    self.communities.index(self.communities.select do |tc|
      tc.consumers.include? prosumer
    end.first) || "N"
  end

  def realtime?
    (communities.first || Community.first)&.realtime?
  end

  def initDates
    if self.cl_scenario&.starttime and self.cl_scenario&.endtime and self.cl_scenario&.interval_id
      {
          start_date: self.cl_scenario.starttime,
          end_date: self.cl_scenario.endtime,
          interval_id: self.cl_scenario.interval_id,
          duration: '',
          type: "Historical"
      }
    else
      (self.communities&.first&.consumers&.first || Consumer.first)&.initDates
    end
  end
end
