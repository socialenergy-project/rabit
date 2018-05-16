require 'upsert/active_record_upsert'

module FetchData
  class FetchData
    def initialize(consumers, chart_cookies)
      puts "INIT: Consumers are #{consumers}, cookies: #{chart_cookies}"
      @consumers = consumers.select { |c| c&.consumer_category&.name == "CTI" }
      @chart_cookies = chart_cookies
    end

    def sync
      puts "Consumers are #{@consumers}, cookies: #{@chart_cookies}"

      if @consumers.length > 0

        interval = Interval.find(@chart_cookies[:interval_id])
        res = JSON.parse RestClient.get ENV['EDMS_URL'], params: {
            mac: @consumers.map{ |c| c.edms_id },
            starttime: @chart_cookies[:start_date],
            endtime: @chart_cookies[:end_date],
            interval: interval.duration
        }

        puts "We got this data #{res}"
        now = DateTime.now
        res.each do |r|
          consumer_hash ||= {}
          consumer_hash[r["mac"]] ||= Consumer.find_by(edms_id: r["mac"]).id
          DataPoint.upsert({
                              consumer_id: consumer_hash[r["mac"]],
                              timestamp: r["timestamp"],
                              interval_id: interval.id,
                          }, consumption: r['kwhinterval'],
                           created_at: now,
                           updated_at: now)

        end

        puts "AFTER UPSERT"
      end


    end
  end
end