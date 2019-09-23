class SmartPlugChannel < ApplicationCable::Channel
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    @smart_plug = params[:smart_plug]
    logger.debug "Smart plug: My params are #{params}"
    stream_from "smart_plug_channel_#{@smart_plug}"
  end

  def receive(data)
    Rails.logger.debug "AAAAAAAAAAAAAAAAAAAAAAAAAAAa RECEIVED MESSAGE"
    uri = URI.parse ENV['MQTT_URL'] || 'mqtt://localhost:1883'

    conn_opts = {
      remote_host: uri.host,
      remote_port: uri.port,
    }

    conn_opts.merge!(
      username: uri.user,
      password: URI.unescape(uri.password),
      ssl: true
    ) if ENV['MQTT_URL']

    consumer = SmartPlug.find_by(mqtt_name: @smart_plug)&.consumer&.edms_id
    Rails.logger.debug "consumer is #{consumer}, #{data}"

    return unless %w(ON OFF).include? data['message']
    if consumer
      Rails.logger.debug "consumer is #{consumer}, #{data['message']}"
      MQTT::Client.connect(conn_opts) do |c|
        Rails.logger.debug "Connected"
        topic = "hscnl/#{consumer}/sendcommand/#{@smart_plug}_Switch"
        Rails.logger.debug "topic is #{topic}"
        c.publish(topic, data['message'], retain=false)
        Rails.logger.debug "published"
      end
    end
  end
end
