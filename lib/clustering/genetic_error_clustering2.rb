require "clustering/ai4r_modifications"
require 'csv'

module ClusteringModule


  class GeneticErrorClustering

    attr_accessor :last_run_stats
    def initialize(consumers: Consumer.all,
                   startDate: Time.now - 1.week,
                   endDate: Time.now,
                   algorithm: Ai4r::GeneticAlgorithm::StaticChromosome,
                   forecast_type: :edms,
                   penalty_violation: 0.3, penalty_satisfaction: 0.2,
                   population_size: 200, generations: 100,
                   interval_id: 2)
      method(__method__).parameters.each do |type, k|
        next unless type == :key
        v = eval(k.to_s)
        instance_variable_set("@#{k}", v) unless v.nil?
        Rails.logger.debug("key: @#{k}")
        Rails.logger.debug("value: #{v}")
      end
      forecasts = {}
=begin
      Hash[
          forecast_type == :edms ?
              DataPoint.where(consumer: @consumers,
                              interval: 2,
                              f_timestamp: @startDate .. @endDate)
                  .select("f_timestamp, consumer_id, COALESCE(f_consumption,0) - COALESCE(f_production,0) as f_prosumption")
                  .map do |dp|
                [[dp.consumer_id, dp.f_timestamp.to_i], dp.f_prosumption]
              end :
              Forecast.day_ahead
                  .where(consumer: @consumers, interval: 2, timestamp: @startDate .. @endDate)
                  .select("timestamp, consumer_id, COALESCE(consumption,0) - COALESCE(production,0) as prosumption")
                  .map do |dp|
                [[dp.consumer_id, dp.timestamp.to_i], dp.prosumption]
              end
      ]
=end

      real = Hash[DataPoint.where(consumer: @consumers,
                                   interval: @interval_id,
                                   timestamp: @startDate .. @endDate)
                      .select("timestamp, consumer_id, COALESCE(consumption,0) as consumption")
                      .map do |dp|
        [[dp.consumer_id, dp.timestamp.to_i], dp.consumption]
      end]
      p real
      @errors = Hash[real.map do |k, v|
                       [k, (v || 0) - (forecasts[k] || 0)]
                     end]
    end

    def run(kappa = 5)
      @lastRunSTats = {start_run: Time.now}

      puts "Beginning genetic search, please wait... "
      search = Ai4r::GeneticAlgorithm::GeneticSearchWithOptions.new(
          @population_size, @generations, errors: @errors, consumer_ids: @consumers.map{|p| p.id}, kappa: kappa,
          penalty_violation: @penalty_violation,
          penalty_satisfaction: @penalty_satisfaction,
          class: @algorithm,
          stats: @lastRunSTats)
      best = search.run
      puts "FITNESS #{best.fitness} CLUSTERS: "+
               "#{best.data.zip(@consumers).map {|c,p| [p.id, c]}}"


      result = []
      best.data.each_with_index do |g, i|
        result[g] ||= []
        result[g].push i
      end

      result.reject!{ |c| c.nil? || c.empty?}

      result.map.with_index do |cl, i|
        Community.new(name: "Genetic #{i}",
                        description: "Genetic clustering #{i}",
                        consumers: cl.map { |p| @consumers[p]})
      end
    end

    def run_cluster(kappa = 5)
      @lastRunSTats = {start_run: Time.now}

      puts "Beginning genetic search, please wait... "

      params = [@population_size, @generations, {errors: @errors, consumer_ids: @consumers.map{|p| p.id}, kappa: kappa,
                penalty_violation: @penalty_violation,
                penalty_satisfaction: @penalty_satisfaction,
                class: @algorithm,
                stats: @lastRunSTats}]

      filename = "/home/dimitriv/upatras/vimsen/worker/vals.json"
      File.open(filename, "w") do |file|
        file.puts JSON.pretty_generate params
      end
      output = `/home/dimitriv/upatras/vimsen/worker/worker.rb '#{filename}'`


      res = JSON.parse output[/###RESULT####(.*?)###RESULT####/m, 1]


      puts "Fitness #{res["fitness"]}"
      data = res["data"]

      puts "Data is: #{data}"

      result = []
      data.each_with_index do |g, i|
        result[g] ||= []
        result[g].push i
      end
      result.reject{ |c| c.nil? || c.empty?}

      result.map.with_index do |cl, i|
        Community.new(name: "Genetic #{i}",
                        description: "Genetic clustering #{i}",
                        consumers: cl.map { |p| @consumers[p]})
      end


    end

    def dump_stats(file)
      CSV.open(file, "w", {:col_sep => "\t"}) do |csv|
        csv << ["generation", "time", "fitness"]
        @lastRunSTats[:gen].each_with_index do |e, i|
          csv << [i, e[:time], e[:fitness]]
        end
      end
    end
  end
end
