# job = Sidekiq::Cron::Job.new(name: 'DbFetchJob - every 1min', cron: '* * * * *', class: 'DbFetchJob', active_job: true) # execute at every 5 minutes, ex: 12:05, 12:10, 12:15...etc

# job.save

# if job.errors.count > 0
#   puts "Counld not create job! #{job.inspect}"
#   puts job.errors #will return array of errors
# end

# Rails.logger.debug "The jobs are #{Sidekiq::Cron::Job.all}, #{job.inspect}"

Sidekiq.default_worker_options = {
  unique: :until_executed,
  unique_args: ->(args) { [ args.first.except('job_id') ] }
}

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://localhost:6379/rat_production"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://localhost:6379/rat_production"
  }
end
