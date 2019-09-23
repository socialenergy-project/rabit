class MonitorMqttWorker
  include Sidekiq::Worker

  sidekiq_options unique_across_workers: true, queue: 'default'

  def perform(*args)
    Rails.logger.debug "Starting monitor mqtt worker"

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

    topic = 'hscnl/+/state/+/state'

    Rails.logger.debug "Subscribing to #{topic}"

    MQTT::Client.connect(conn_opts) do |c|
      # The block will be called when you messages arrive to the topic
      c.get(topic) do |t, value|
        parts = t.split("/")
        consumer_mac = parts[1]
        smart_plug = parts[3].partition('_')[0]
        event_type = parts[3].partition('_')[-1]

        Rails.logger.debug "consumermac: #{consumer_mac}"
        Rails.logger.debug "smart_plug: #{smart_plug}"
        Rails.logger.debug "event_type: #{event_type}"
        Rails.logger.debug "value: #{value}"

        message = case event_type
                  when 'ElectricMeterWatts'
                    {
                      timestamp: DateTime.now.to_datetime.to_s,
                      event_type: event_type,
                      consumption: value.to_f
                    }
                  when 'Switch'
                    {
                      timestamp: DateTime.now.to_datetime.to_s,
                      event_type: event_type,
                      new_state: value
                    }
                  else
                    {}
                  end
        ActionCable.server.broadcast("smart_plug_channel_#{smart_plug}", message) if message.size > 0
      end

    end
  end
end
