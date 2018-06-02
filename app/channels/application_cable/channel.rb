module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def create_db_channel_name(consumers, interval_id)

      if consumers["community"]

      elsif consumers["consumer"]
        "dp_channel_#{}_#{consumers["community"]}_#{interval_id}"
      end
    end
  end
end
