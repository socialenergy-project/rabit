class DataPointChannel < ApplicationCable::Channel
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    logger.debug "My params are #{params}"
    type, id = params["consumers"].first
    stream_from "dp_channel_#{type}_#{id}_#{params["interval_id"]}"

  end
end