class DrAction < ApplicationRecord
  belongs_to :dr_target
  belongs_to :consumer

  scope :for_timestamp, lambda { |timestamp|
    joins(dr_target: { dr_event: :interval })
      .where(":ts >= dr_events.starttime + dr_targets.ts_offset * intervals.duration * (interval '1 second') AND :ts < dr_events.starttime + (dr_targets.ts_offset + 1) * intervals.duration * (interval '1 second') ", ts: timestamp)
  }

  scope :for_timestamp_range, lambda { |timestamp1, timestamp2|
    joins(dr_target: { dr_event: :interval })
      .where("(:ts1 >= dr_events.starttime + dr_targets.ts_offset * intervals.duration * (interval '1 second') AND :ts1 < dr_events.starttime + (dr_targets.ts_offset + 1) * intervals.duration * (interval '1 second'))
         OR (:ts2 > dr_events.starttime + dr_targets.ts_offset * intervals.duration * (interval '1 second') AND :ts2 <= dr_events.starttime + (dr_targets.ts_offset + 1) * intervals.duration * (interval '1 second'))", ts1: timestamp1, ts2: timestamp2)
  }
end
