require 'fetch_data/flexgrid_client'

module FetchData
  class FetchData
    Upsert.logger = Logger.new("/dev/null")

    def initialize(consumers, chart_cookies)
      @interval = Interval.find(chart_cookies[:interval_id]&.to_i)
      @consumers = consumers

      interval_duration = @interval.duration.seconds

      interval_duration = 5.minutes unless interval_duration > 5.minutes

      start = chart_cookies[:type] == 'Real-time' ?
          DateTime.now - chart_cookies[:duration].to_i.seconds - 2 * interval_duration :
          chart_cookies[:start_date].to_datetime - 2 * interval_duration
      stop = chart_cookies[:type] == 'Real-time' ?
          DateTime.now + (chart_cookies[:duration].to_i / 5.0).seconds :
          chart_cookies[:end_date].to_datetime + 2 * interval_duration

      @params = {
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
      new_data_points = download(@params.merge(mac: @consumers.select{|c| [2,3].include? c.consumer_category_id}.map(&:edms_id).join(",") ))
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

    def download(params)
      Rails.logger.debug "We need: #{@consumers.length * @interval.timestamps(params[:starttime], params[:endtime]).count} points"
      Rails.logger.debug "We have: #{DataPoint.where(consumer: @consumers, interval: @interval, timestamp: params[:starttime]..params[:endtime]).count} points"

      JSON.parse RestClient.get ENV['EDMS_URL'], params: params

    end

    def download_flex(params)
      Rails.logger.debug "FLEX: We need: #{@consumers.length * @interval.timestamps(params[:starttime], params[:endtime]).count} points"
      Rails.logger.debug "FLEX: We have: #{DataPoint.where(consumer: @consumers, interval: @interval, timestamp: params[:starttime]..params[:endtime]).count} points"

      FlexgridClient.data_points(params[:starttime].utc.strftime('%Y-%m-%dT%H:%M:%S'), params[:endtime].utc.strftime('%Y-%m-%dT%H:%M:%S'), params[:consumers], @interval.duration)

    end

    def upsert(res)
#       Rails.logger.debug "We got this data #{res}"
      now = DateTime.now

      consumer_hash = {}
      interval_id = @interval.id
      DataPoint.bulk_insert ignore: true, values: (res.map do |r|
        consumer_hash[r["mac"]] ||= Consumer.find_by(edms_id: r["mac"]).id
        {
            consumer_id: consumer_hash[r["mac"]],
            timestamp: r["timestamp"],
            interval_id: interval_id,
            consumption: r['kwhinterval'],
        }
      end)
    end

    def upsert_flex(res)
      # Rails.logger.debug "We received: #{JSON.pretty_generate new_data.to_a}"
      now = DateTime.now

      consumer_hash = {}
      interval_id = @interval.id
      interval_duration = @interval.duration
      DataPoint.bulk_insert ignore: true, values: (res.map do |r|
        mac = r["_id"]["prosumer_id"]
        consumer_hash[mac] ||= Consumer.find_by(edms_id: mac).id
        {
            consumer_id: consumer_hash[mac],
            timestamp: r["_id"]["date"],
            interval_id: interval_id,
            consumption: (r['grid_consumption_w_aggr'].to_f - r['grid_feed_in_w_aggr'].to_f) / 1000 * interval_duration / 1.hour,
        }
      end)

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

        # Get from socialenergy EDMS db
        edms_consumers = @consumers.select{|c| [2,3].include? c.consumer_category_id}
        if edms_consumers.any?
          socialenerg_data_points = download @params.merge(mac: edms_consumers.map(&:edms_id).join(",") )
          upsert socialenerg_data_points
        end

        # Get from flexgrid db
        flexgrid_consumers = @consumers.select{|c| [4].include? c.consumer_category_id}
        if flexgrid_consumers.any?
          flexgrid_data_points = download_flex @params.merge(consumers: flexgrid_consumers.map(&:edms_id) )
          upsert_flex flexgrid_data_points
        end
      end
    end
  end
end
