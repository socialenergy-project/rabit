# job = Sidekiq::Cron::Job.new(name: 'DbFetchJob - every 1min', cron: '* * * * *', class: 'DbFetchJob', active_job: true) # execute at every 5 minutes, ex: 12:05, 12:10, 12:15...etc

# job.save

# if job.errors.count > 0
#   puts "Counld not create job! #{job.inspect}"
#   puts job.errors #will return array of errors
# end

# Rails.logger.debug "The jobs are #{Sidekiq::Cron::Job.all}, #{job.inspect}"

=begin
Sidekiq.default_worker_options = {
  unique: :until_and_while_executing,
  unique_args: ->(args) { [ args.first.except('job_id') ] }
}
=end

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://localhost:6379/8"
  }
  config.on(:startup) do
    p "ON STARTUP CODE"
    workers = Sidekiq::Workers.new
    p "The scheduledSet is #{workers .inspect}"
    redis_workers = workers.select do |process_id, thread_id, work|
      work['payload']['class'] == "MonitorRedisWorker"
    end # .each &:delete

    in_queue = Sidekiq::Queue.new.select do |job|
      job.klass == "MonitorRedisWorker"
    end

    scheduled = Sidekiq::ScheduledSet.new.select {|job| job.klass == "MonitorRedisWorker" }

    p "We have #{scheduled.count} scheduled, #{in_queue.count} in queue, and #{redis_workers.count} workers."

    already_scheduled = scheduled.count + in_queue.count + redis_workers.count
    MonitorRedisWorker.perform_async if already_scheduled == 0
  end
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://localhost:6379/8"
  }
end
