class MonitorRedisWorker
  include Sidekiq::Worker

  sidekiq_options unique_across_workers: true, queue: 'default'

  def perform(*args)
    Rails.logger.debug "Starting monitor redis worker"
    redis = Redis.new
    redis.subscribe('dp_channel_all', 'ruby-lang') do |on|
      on.message do |channel, msg|
        Rails.logger.debug "Received #{msg.inspect}"
        data = JSON.parse(msg)
        data_point = {
            interval_id: Interval.find_by(duration: data["interval"]).id,
            timestamp: data["timestamp"].to_datetime.to_s,
            consumer: Consumer.find_by(edms_id: data['mac']),
            consumption: data["kwhinterval"]
        }

        if data_point[:consumer]
          ActionCable.server.broadcast("dp_channel_consumer_#{data_point[:consumer].id}_#{data_point[:interval_id]}", data_point)
          data_point[:consumer].reload.communities.reload.each do |community|
            ActionCable.server.broadcast("dp_channel_community_#{community.id}_#{data_point[:interval_id]}", data_point)
          end
        else
          Rails.logger.debug "Received data for unregistered consumer"
        end
      end
    end
  end
end
