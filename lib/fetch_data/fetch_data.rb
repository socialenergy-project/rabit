module FetchData
  class FetchData
    Upsert.logger = Logger.new("/dev/null")

    def initialize(consumers, chart_cookies)
      @interval = Interval.find(chart_cookies[:interval_id])
      @consumers = consumers.select {|c| c&.consumer_category&.name == "ICCS"}
      @params = {
          mac: @consumers.map {|c| c.edms_id}.join(","),
          starttime: chart_cookies[:start_date],
          endtime: chart_cookies[:end_date],
          interval: @interval.duration
      }
    end

    def download
      Rails.logger.debug "We need: #{@consumers.length * @interval.timestamps(@params[:starttime], @params[:endtime]).count} points"
      Rails.logger.debug "We have: #{DataPoint.where(consumer: @consumers, interval: @interval, timestamp: @params[:starttime]..@params[:endtime]).count} points"

      res = JSON.parse RestClient.get ENV['EDMS_URL'], params: @params

      Rails.logger.debug "We got this data #{res}"
      now = DateTime.now

      ActiveRecord::Base.connection_pool.with_connection do |conn|
        Upsert.batch(conn, DataPoint.table_name) do |upsert|
          consumer_hash = {}
          interval_id = @interval.id
          res.each do |r|
            consumer_hash[r["mac"]] ||= Consumer.find_by(edms_id: r["mac"]).id
            upsert.row({
                           consumer_id: consumer_hash[r["mac"]],
                           timestamp: r["timestamp"],
                           interval_id: interval_id,
                       }, consumption: r['kwhinterval'],
                       created_at: now,
                       updated_at: now)

          end
        end
      end
    end

    def sync
      Rails.logger.debug "Consumers are #{@consumers}, params: #{@params}"

      if @consumers.length > 0
        in_db = @consumers.map{|c| [c.id, 0 ]}.to_h.merge(
            DataPoint
                .where(consumer: @consumers,
                       interval: @interval,
                       timestamp: @params[:starttime]..@params[:endtime])
                .group(:consumer_id)
                .count
        )

        total_per_consumer = @interval.timestamps(@params[:starttime], @params[:endtime]).count

        @consumers = @consumers.reject do |c|
          in_db[c.id] == total_per_consumer
        end


        if @consumers.count == 0
          Rails.logger.debug "We have all the #{total_per_consumer} points we need., in_db=#{in_db}"
          return
        end

        @params[:starttime] = @consumers.map do |c|
          midpoint = @params[:starttime] + in_db[c.id] * @interval.duration.seconds
          puts "Consumer #{c.id}"
          puts "start: #{@params[:starttime]}"
          puts "end: #{@params[:endtime]}"
          puts "midpoint: #{midpoint}"
          puts "in_db: #{in_db[c.id]}"
          puts "total: #{total_per_consumer}"
          puts "points til mid #{DataPoint.where(consumer: c,
                                                 interval: @interval,
                                                 timestamp: @params[:starttime]..midpoint).count}"
          puts "we want #{@interval.timestamps(@params[:starttime], midpoint).count}"

          if DataPoint.where(consumer: c,
                             interval: @interval,
                             timestamp: @params[:starttime]..midpoint).count == in_db[c.id]
            midpoint
          else
            @params[:starttime]
          end
        end.min



        puts "start: #{@params[:starttime]}"
        puts "end: #{@params[:endtime]}"
        download
      end
    end
  end
end
