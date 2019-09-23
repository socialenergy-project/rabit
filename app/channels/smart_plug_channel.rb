class SmartPlugChannel < ApplicationCable::Channel
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    logger.debug "Smart plug: My params are #{params}"
    stream_from "smart_plug_channel_#{params[:smart_plug]}"
  end
end