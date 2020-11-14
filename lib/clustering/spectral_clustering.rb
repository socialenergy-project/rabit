require 'clustering/spectral_clustering_algorithm'


module ClusteringModule

  class SpectralClustering

    def initialize(consumers: Consumer.all,
                   startDate: Time.now - 1.week,
                   endDate: Time.now,
                   interval_id: 2,
                   forecast_type: :edms)
      method(__method__).parameters.each do |type, k|
        next unless type == :key
        v = eval(k.to_s)
        instance_variable_set("@#{k}", v) unless v.nil?
        Rails.logger.debug("key: @#{k}")
        Rails.logger.debug("value: #{v}")
      end

      @forecasts = {}
=begin
      Hash[
          forecast_type == :edms ?
              DataPoint.where(consumer: @consumers,
                              interval: @interval_id,
                              f_timestamp: @startDate .. @endDate)
                  .select("f_timestamp, consumer_id, COALESCE(f_consumption,0) as f_prosumption")
                  .map do |dp|
                [[dp.consumer_id, dp.f_timestamp.to_i], dp.f_prosumption]
              end :
              Forecast.day_ahead
                  .where(consumer: @consumers, interval: @interval_id, timestamp: @startDate .. @endDate)
                  .select("timestamp, consumer_id, COALESCE(consumption,0) as prosumption")
                  .map do |dp|
                [[dp.consumer_id, dp.timestamp.to_i], dp.prosumption]
              end
      ]
=end

      @consumers = DataPoint.includes(:consumer).where(consumer: @consumers,
                      interval: @interval_id,
                      timestamp: @startDate .. @endDate)
          .group(:consumer_id).select('consumer_id, min(consumption) as c') #.reject{|d| d.c < 0.1}
          .map{|d| d.consumer}

=begin
      @consumers = @consumers.reject do |c|
        c.data_points.where(interval: @interval_id,
                            timestamp: @startDate .. @endDate).maximum(:consumption) < 0.1
      end
=end

      @real =  Hash[DataPoint.where(consumer: @consumers,
                                    interval: @interval_id,
                                    timestamp: @startDate .. @endDate)
                        .select("timestamp, consumer_id, COALESCE(consumption,0) as prosumption")
                        .map do |dp|
        [[dp.consumer_id, dp.timestamp.to_i], dp.prosumption]
      end]

      @timestamps = Hash[@consumers.map{|p| [p.id,[]] }]

      @errors = Hash[@real.map do |(pid,timestamp),v|
                       # @timestamps[pid] ||= []
                       @timestamps[pid].push timestamp unless v.nil?
                       [ [pid, timestamp], (v || 0) - (@forecasts[[pid, timestamp]] || 0)]
                     end]

      @similarity_matrix = generate_similarity_matrix

    end

    def generate_similarity_matrix
      raise "Use a subclass that implements this method"
    end

    def run(kappa = 5)

      sc = SpectralClusteringAlgorithm.new(@similarity_matrix)

      clusters = sc.run(kappa)

      clusters.map.with_index do |cl, i|
        Community.new(name: "Spectral #{i}",
                        description: "Spectral error clustering #{i}",
                        consumers: cl.map { |p| @consumers[p]})
      end
    end

    def cross_correlation(vector, pid1, pid2)

      common_timestamps = @timestamps[pid1] & @timestamps[pid2]

      s12 = common_timestamps.sum{|ts| vector[[pid1, ts]] * vector[[pid2, ts]]}
      s11 = common_timestamps.sum{|ts| vector[[pid1, ts]] ** 2 }
      s22 = common_timestamps.sum{|ts| vector[[pid2, ts]] ** 2 }

      return 0 if (s11 == 0 || s22 == 0)
      s12 / ( s11 ** 0.5 * s22 ** 0.5)
    end

    def stats(clusters)
      sum_same = sum_different = 0.0;
      count_same = count_different = 0
      @consumers.combination(2) do |pi,pj|
        i = @consumers.index(pi)
        j = @consumers.index(pj)

        if same_cluster(clusters, i,j)
          sum_same += @similarity_matrix[i,j]
          count_same += 1
        else
          sum_different += @similarity_matrix[i,j]
          count_different += 1
        end
      end
      {
          ingroup: sum_same / count_same,
          outgroup: sum_different / count_different
      }
    end

    def same_cluster(clusters, i,j)
      clusters.find{|k| k.include? i} == clusters.find{|k| k.include? j}
    end
  end

  class PositiveErrorSpectralClustering < SpectralClustering
    def generate_similarity_matrix
      Matrix.build(@consumers.length, @consumers.length)  do |row, col|
        cross_correlation(@errors, @consumers[row].id, @consumers[col].id)
      end
    end
  end

  class NegativeErrorSpectralClustering < SpectralClustering
    def generate_similarity_matrix
      Matrix.build(@consumers.length, @consumers.length)  do |row, col|
        1 - cross_correlation(@errors, @consumers[row].id, @consumers[col].id).abs
      end
    end
  end

  class PositiveConsumptionSpectralClustering < SpectralClustering
    def generate_similarity_matrix
      Matrix.build(@consumers.length, @consumers.length)  do |row, col|
        cross_correlation(@real, @consumers[row].id, @consumers[col].id)
      end
    end
  end

  class NegativeConsumptionSpectralClustering < SpectralClustering
    def generate_similarity_matrix
      Matrix.build(@consumers.length, @consumers.length)  do |row, col|
        1 - cross_correlation(@real, @consumers[row].id, @consumers[col].id).abs
      end
    end
  end

end
