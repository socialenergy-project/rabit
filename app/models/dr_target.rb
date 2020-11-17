# frozen_string_literal: true

class DrTarget < ApplicationRecord
  belongs_to :dr_event
  has_many :dr_actions
  has_many :dr_plan_actions, dependent: :destroy

  def timestamp_start
    dr_event.starttime + dr_event.interval.duration * ts_offset
  end

  def timestamp_stop
    dr_event.starttime + dr_event.interval.duration * (ts_offset + 1)
  end
end
