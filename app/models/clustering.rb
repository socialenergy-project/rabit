class Clustering < ApplicationRecord
  has_many :communities, dependent: :destroy

  validates_associated :communities, message: ->(_class_obj, obj){ p "community OBJ is ", obj[:value]; obj[:value].map(&:errors).map(&:full_messages).join(',') }

  has_one :cl_scenario, dependent: :nullify

  def get_icon_index(prosumer)
    self.communities.index(self.communities.select do |tc|
      tc.consumers.include? prosumer
    end.first) || "N"
  end

  def initDates
    (communities.first || Consumer.first)&.initDates
  end
end
