class DrEventWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'scheduler'

  def perform(*_args)
    timestamp = DateTime.now
    logger.debug "running at #{timestamp}"

    actions_to_activate = DrAction.includes(:consumer).for_timestamp(timestamp).where(activated_at: nil)
    actions_to_deactivate = DrAction.includes(:consumer).where('activated_at IS NOT NULL AND deactivated_at IS NULL') - DrAction.includes(:consumer).for_timestamp(timestamp)

    logger.debug "Current actions to be deactivated: #{actions_to_deactivate.pluck(:consumer_id)}"
    actions_to_deactivate.each { |dra| deactivate_dr(dra, timestamp) }

    logger.debug "Current actions to be activated: #{actions_to_activate.pluck(:consumer_id)}"
    actions_to_activate.each { |dra| activate_dr(dra, timestamp) }

    true
  end

  def deactivate_dr(dr_action, timestamp)
    topic = "site_max_consumption/#{dr_action.consumer.edms_id[/\d+/].to_i}"
    send_to_mqtt(topic, { 'message': 'DR_OFF' }.to_json)
    dr_action.update(deactivated_at: timestamp)
  end

  def activate_dr(dr_action, timestamp)
    last_data_point = DataPoint.includes(:interval).where(consumer_id: dr_action.consumer_id).order(timestamp: :desc).first
    target = (last_data_point ? last_data_point.consumption / (last_data_point.interval.duration.to_f / 1.hour) : 0.0) - (dr_action.volume_planned * 1e6)
    topic = "site_max_consumption/#{dr_action.consumer.edms_id[/\d+/].to_i}"
    send_to_mqtt(topic, target)
    dr_action.update(activated_at: timestamp)
  end

  def send_to_mqtt(topic, msg)
    uri = URI.parse ENV['MQTT_URL'] || 'mqtt://localhost:1883'

    conn_opts = {
      remote_host: uri.host,
      remote_port: uri.port
    }

    if ENV['MQTT_URL']
      conn_opts.merge!(
        username: uri.user,
        password: URI.unescape(uri.password),
        ssl: true
      )
    end
    logger.debug 'Trying to connect to MQTT'
    MQTT::Client.connect(conn_opts) do |c|
      logger.debug "We are connected, topic is: #{topic}, msg: #{msg}"
      c.publish(topic, msg)
    end
  end
end
