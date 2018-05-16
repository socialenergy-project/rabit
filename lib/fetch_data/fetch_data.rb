module FetchData
  class FetchData
    def initialize(consumers, chart_cookies)
      @consumers = consumers.select {|c| c&.consumer_category&.name == "CTI"}
      @chart_cookies = chart_cookies
    end

    def sync
      Rails.logger.debug "Consumers are #{@consumers}, cookies: #{@chart_cookies}"

      interval = Interval.find(@chart_cookies[:interval_id])
      if @consumers.length > 0 &&
          @consumers.length * interval.timestamps(@chart_cookies[:start_date], @chart_cookies[:end_date]).count !=
              DataPoint.where(consumer: @consumers,
                              interval: interval,
                              timestamp: @chart_cookies[:start_date]..@chart_cookies[:end_date]).count
        Rails.logger.debug "We need: #{@consumers.length * interval.timestamps(@chart_cookies[:start_date], @chart_cookies[:end_date]).count} points"
        Rails.logger.debug "We have: #{DataPoint.where(consumer: @consumers, interval: interval, timestamp: @chart_cookies[:start_date]..@chart_cookies[:end_date]).count} points"

        res = JSON.parse RestClient.get ENV['EDMS_URL'], params: {
            mac: @consumers.map {|c| c.edms_id},
            starttime: @chart_cookies[:start_date],
            endtime: @chart_cookies[:end_date],
            interval: interval.duration
        }

        Rails.logger.debug "We got this data #{res}"
        now = DateTime.now

        ActiveRecord::Base.connection_pool.with_connection do |conn|
          Upsert.batch(conn, DataPoint.table_name) do |upsert|
            consumer_hash = {}
            res.each do |r|
              consumer_hash[r["mac"]] ||= Consumer.find_by(edms_id: r["mac"]).id
              upsert.row({
                             consumer_id: consumer_hash[r["mac"]],
                             timestamp: r["timestamp"],
                             interval_id: @chart_cookies[:interval_id],
                         }, consumption: r['kwhinterval'],
                         created_at: now,
                         updated_at: now)

            end
          end
        end
      end
    end
  end
end