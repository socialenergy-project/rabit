require 'oauth2'

module FetchData
  # Client for downloading from the FLEXGRID central database server
  module FlexgridClient
    def self.token
      @token ||= OAuth2::Client
                 .new(ENV['FLEXGRID_CLIENT'], '', site: ENV['FLEXGRID_URL'])
                 .password.get_token(ENV['FLEXGRID_USER'], ENV['FLEXGRID_PASSWORD'])
      @token = @token.refresh! if @token.expired?
      @token
    end

    def self.prosumers(params = {})
      get_all '/prosumers/', params
    end

    def self.data_points(start_time, end_time, prosumers, interval)
      data_points_aggr aggregate: { '$start': start_time, '$end': end_time,
                                    '$prosumer_ids': prosumers, '$interval': interval }.to_json
    end

    def self.data_points_aggr(params = {})
      get_all '/data_points_aggr/', params
    end

    def self.get_all(path, params = {})
      Enumerator.new do |yielder|
        loop do
          Rails.logger.debug "Requesting '#{path}', params:'#{params}'"
          result = get_single path, params
          result['_items'].each { |item| yielder << item }
          break unless result['_links']['next']

          path = result['_links']['next']['href']
        end
      end
    end

    def self.get_single(path, params = {})
      JSON.parse(token.get(path, params: params.merge(max_results: 10_000)).body)
    end
  end
end
