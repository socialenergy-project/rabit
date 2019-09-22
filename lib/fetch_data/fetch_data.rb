module FetchData
  class FetchData
    Upsert.logger = Logger.new("/dev/null")

    def initialize(consumers, chart_cookies)
      @interval = Interval.find(chart_cookies[:interval_id]&.to_i)
      @consumers = consumers.select {|c| c&.realtime?}
      start = chart_cookies[:type] == 'Real-time' ?
          DateTime.now - chart_cookies[:duration].to_i.seconds :
          chart_cookies[:start_date].to_datetime
      stop = chart_cookies[:type] == 'Real-time' ?
          DateTime.now + (chart_cookies[:duration].to_i / 5.0).seconds :
          chart_cookies[:end_date].to_datetime

      @params = {
          mac: @consumers.map {|c| c.edms_id}.join(","),
          starttime: start,
          endtime: stop,
          interval: @interval.duration
      }
    end

    def pollchanges
      last = @consumers.map{|c| [c.edms_id, 0 ]}.to_h.merge(
          DataPoint
              .joins(:consumer)
              .where(consumer: @consumers,
                     interval: @interval,
                     timestamp: @params[:starttime]..@params[:endtime])
              .group(:edms_id)
              .select('edms_id, max(timestamp) as last')
              .map{|dp| [dp.edms_id, dp.last]}.to_h

      )
      p "The last ones are #{last}"
      new_data_points = download
                            .reject{|d| d["timestamp"].to_datetime < last[d["mac"]]}


      publish_to_channel new_data_points.map { |d|
        {
            interval_id: @interval.id,
            timestamp: d["timestamp"].to_datetime.to_s,
            consumer: Consumer.find_by(edms_id: d['mac']),
            consumption: d["kwhinterval"]
        }
      }
      upsert new_data_points
    end

    def publish_to_channel(data_points)
      data_points.each do |dp|
        ActionCable.server.broadcast("dp_channel_consumer_#{dp[:consumer].id}_#{dp[:interval_id]}", dp)
        dp[:consumer].communities.each do |community|
          ActionCable.server.broadcast("dp_channel_community_#{community.id}_#{dp[:interval_id]}", dp)
        end
      end

    end

    def download
      Rails.logger.debug "We need: #{@consumers.length * @interval.timestamps(@params[:starttime], @params[:endtime]).count} points"
      Rails.logger.debug "We have: #{DataPoint.where(consumer: @consumers, interval: @interval, timestamp: @params[:starttime]..@params[:endtime]).count} points"

      JSON.parse RestClient.get ENV['EDMS_URL'], params: @params

    end

    def upsert(res)
#       Rails.logger.debug "We got this data #{res}"
      now = DateTime.now

      consumer_hash = {}
      interval_id = @interval.id
=begin
      fparams = {
        table: 'data_points',
        static_columns: {
          interval_id: interval_id
        },
        options: {
          timestamps: true,
          unique: true,
          check_for_existing: true
        },
        group_size: 2000,
        variable_columns: %w(consumer_id timestamp consumption),
        values: res.map { |r|
#          Rails.logger.debug "r is #{r}"
          consumer_hash[r["mac"]] ||= Consumer.find_by(edms_id: r["mac"]).id
          [
            consumer_hash[r["mac"]],
            r["timestamp"],
            r['kwhinterval']
          ]
        }
      }
#       Rails.logger.debug "fparams are constructed: #{fparams}"
      Rails.logger.debug "Done1"
      inserter = FastInserter::Base.new(fparams)
      Rails.logger.debug "Done2"
      inserter.fast_insert
      Rails.logger.debug "Done3"
=end

      DataPoint.bulk_insert ignore: true, values: (res.map do |r|
        consumer_hash[r["mac"]] ||= Consumer.find_by(edms_id: r["mac"]).id
        {
            consumer_id: consumer_hash[r["mac"]],
            timestamp: r["timestamp"],
            interval_id: interval_id,
            consumption: r['kwhinterval'],
        }
      end)


=begin
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
=end

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
          Rails.logger.debug "Consumer #{c.id}"
          Rails.logger.debug "start: #{@params[:starttime]}"
          Rails.logger.debug "end: #{@params[:endtime]}"
          Rails.logger.debug "midpoint: #{midpoint}"
          Rails.logger.debug "in_db: #{in_db[c.id]}"
          Rails.logger.debug "total: #{total_per_consumer}"
          Rails.logger.debug "points til mid #{DataPoint.where(consumer: c,
                                                 interval: @interval,
                                                 timestamp: @params[:starttime]..midpoint).count}"
          Rails.logger.debug "we want #{@interval.timestamps(@params[:starttime], midpoint).count}"

          if DataPoint.where(consumer: c,
                             interval: @interval,
                             timestamp: @params[:starttime]..midpoint).count == in_db[c.id]
            midpoint
          else
            @params[:starttime]
          end
        end.min

        Rails.logger.debug "start: #{@params[:starttime]}"
        Rails.logger.debug "end: #{@params[:endtime]}"
        new_points = download
        upsert(new_points)
      end
    end
  end
end
