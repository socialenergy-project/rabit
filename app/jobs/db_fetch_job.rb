require 'fetch_data/fetch_data'

class DbFetchJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.debug "#{DateTime.now} Cron job executed"
    Interval.all.each do |i|
      fd = FetchData::FetchData.new(
          ConsumerCategory.find_by(name: 'ICCS').consumers,
          {
              interval_id: i.id,
              start_date: DateTime.now - 1.hour,
              end_date: DateTime.now + 1.hour
          }
      )
      fd.pollchanges
    end

  end
end
