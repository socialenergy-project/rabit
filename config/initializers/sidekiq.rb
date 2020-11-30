# job = Sidekiq::Cron::Job.new(name: 'DbFetchJob - every 1min', cron: '* * * * *', class: 'DbFetchJob', active_job: true) # execute at every 5 minutes, ex: 12:05, 12:10, 12:15...etc

# job.save

# if job.errors.count > 0
#   puts "Counld not create job! #{job.inspect}"
#   puts job.errors #will return array of errors
# end

# Rails.logger.debug "The jobs are #{Sidekiq::Cron::Job.all}, #{job.inspect}"

# Sidekiq.default_worker_options = {
#   unique: :until_and_while_executing,
#   unique_args: ->(args) { [ args.first.except('job_id') ] }
# }

Sidekiq.configure_server do |config|
  config.redis = {
    url: 'redis://localhost:6379/8'
  }

  config.logger.level = Logger::DEBUG

  # ActiveJob::Base.logger = Logger.new('log/sidekiq.log')

  config.on(:startup) do
    Rails.logger.debug 'ON STARTUP CODE'
    workers = Sidekiq::Workers.new
    Rails.logger.debug "The scheduledSet is #{workers.inspect}"
    redis_workers = workers.select do |_process_id, _thread_id, work|
      work['payload']['class'] == 'MonitorRedisWorker'
    end # .each &:delete

    mqtt_workers = workers.select do |_process_id, _thread_id, work|
      work['payload']['class'] == 'MonitorMqttWorker'
    end # .each &:delete

    in_queue = Sidekiq::Queue.new.select do |job|
      job.klass == 'MonitorRedisWorker'
    end

    in_queue_mqtt = Sidekiq::Queue.new.select do |job|
      job.klass == 'MonitorMqttWorker'
    end

    scheduled = Sidekiq::ScheduledSet.new.select { |job| job.klass == 'MonitorRedisWorker' }
    scheduled_mqtt = Sidekiq::ScheduledSet.new.select { |job| job.klass == 'MonitorMqttWorker' }

    Rails.logger.debug "We have #{scheduled.count} scheduled, #{in_queue.count} in queue, and #{redis_workers.count} workers."
    Rails.logger.debug "We have #{scheduled_mqtt.count} scheduled, #{in_queue_mqtt.count} in queue, and #{mqtt_workers.count} workers."

    already_scheduled = scheduled.count + in_queue.count + redis_workers.count
    already_scheduled_mqtt = scheduled_mqtt.count + in_queue_mqtt.count + mqtt_workers.count
    MonitorRedisWorker.perform_async if already_scheduled == 0
    MonitorMqttWorker.perform_async if already_scheduled_mqtt == 0

    #     Rails.logger.debug "THE FILE IS #{File.expand_path("../../sidekiq.yml", __FILE__)}"
    # Sidekiq.schedule = YAML.load_file(File.expand_path("../../sidekiq.yml", __FILE__))
    # Sidekiq::Scheduler.load_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://localhost:6379/8'
  }
end
