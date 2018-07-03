class MonitorRedisJob < ApplicationJob
  queue_as :default

#  rescue_from(StandardError) do
#    retry_job wait: 30.seconds
#  end

  def perform(*args)
    p "Starting monitor redis job"
    redis = Redis.new
    redis.subscribe('dp_channel_all', 'ruby-lang') do |on|
      on.message do |channel, msg|
        p "Received", msg
        data = JSON.parse(msg)
        data_point = {
            interval_id: Interval.find_by(duration: data["interval"]).id,
            timestamp: data["timestamp"].to_datetime.to_s,
            consumer: Consumer.find_by(edms_id: data['mac']).reload,
            consumption: data["kwhinterval"]
        }

        if data_point[:consumer]
          ActionCable.server.broadcast("dp_channel_consumer_#{data_point[:consumer].id}_#{data_point[:interval_id]}", data_point)
          data_point[:consumer].reload.communities.reload.each do |community|
            ActionCable.server.broadcast("dp_channel_community_#{community.id}_#{data_point[:interval_id]}", data_point)
          end
        else
          p "Received data for unregistered consumer"
        end
       end
    end
  end
end
