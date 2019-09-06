require 'clustering/genetic_error_clustering2'
require 'clustering/spectral_clustering'


# This module implements the clustering algorithms for the demo
module ClusteringModule

  def self.algorithms
    {
        building_type: {
            string: 'By building type',
            proc: ->(k) { run_building_type k }
        },
=begin
        connection_type: {
            string: 'By connection type',
            proc: ->(k) { run_connection_type k }
        },
=end
        location: {
            string: 'By location',
            proc: ->(k) { run_location k }
        },
        genetic: {
            string: 'By consumption profile (Genetic)',
            proc: ->(params) {
              ClusteringModule::GeneticErrorClustering.new(
                  consumers: consumers(params),
                  startDate: params[:start_date],
                  endDate: params[:end_date],
                  interval_id: params[:interval_id],
              ).run params[:kappa]
            }
        },
        genetic_smart: {
            string: 'By consumption profile (Genetic – smart)',
            proc: ->(params) {
              ClusteringModule::GeneticErrorClustering.new(
                  consumers: consumers(params),
                  startDate: params[:start_date],
                  endDate: params[:end_date],
                  interval_id: params[:interval_id],
                  algorithm: Ai4r::GeneticAlgorithm::StaticChromosomeWithSmartCrossover,
              ).run params[:kappa]
            }
        },
        positive_consumption_spectral_clustering: {
            string: 'By consumption profile (Spectral – positive)',
            proc: ->(params) {
              ClusteringModule::PositiveConsumptionSpectralClustering.new(
                  consumers: consumers(params),
                  startDate: params[:start_date],
                  endDate: params[:end_date],
                  interval_id: params[:interval_id],
              ).run params[:kappa]
            }
        },
        negative_consumption_spectral_clustering: {
            string: 'By consumption profile (Spectral – negative)',
            proc: ->(params) {
              ClusteringModule::NegativeConsumptionSpectralClustering.new(
                  consumers: consumers(params),
                  startDate: params[:start_date],
                  endDate: params[:end_date],
                  interval_id: params[:interval_id],
              ).run params[:kappa]
            }
        },
        crtp: {
            string: 'Pricing based community formation – CRTP'
        },
        demand_response: {
          string: 'Consumer selection for DR event',
          proc: ->(params) {

            user_consumption_list =  User.joins(consumers: :data_points)
                                          .where('data_points.timestamp': params[:start_date]..params[:end_date],
                                                'data_points.interval_id': params[:interval_id])
                                          .group(:user_id)
                                          .order(sum_data_points_consumption: :desc)
                                          .sum('data_points.consumption')
            remaining = params[:cost_parameter]
            [
              Community.new(
                name: "DR cluster",
                description: "Clustering for sending the DR event",
                consumers: (user_consumption_list.take_while { |user_id, consumption|
                  (remaining -= consumption) > -consumption
                }.map { |user_id, consumption|
                  User.find(user_id).consumers
                }.flatten)
              )
            ]
          }
        }
    }
  end

  def self.run_algorithm(params)
    result = self.algorithms.with_indifferent_access[params[:algorithm]][:proc].call(params)

    result.select { |cl| cl.consumers.size > 0 }
  end

  private

  def self.consumers(params)
    Rails.logger.debug "The ids are #{params[:consumer_ids]}"
    if params[:consumer_ids]
      Consumer.where(id: params[:consumer_ids])
    else
      Consumer.category(ConsumerCategory.find params[:category_id])
    end
  end

  def self.run_energy_type(params)
    result = {}
    cl = Community.new name: 'No ren.',
                     description: 'No info about renewable energy.'
    result[:none] = cl
    EnergyType.all.each do |et|
      cl = Community.new name: "CL: #{et.name}",
                       description: "Consumers with primarily #{et.name} "\
                                    'energy production'
      result[et.id] = cl
    end

    consumers(params).each do |p|
      etp = p.energy_type_consumers.order('power DESC').first
      if etp.nil?
        result[:none].consumers.push(p)
      else
        etid = etp.energy_type.id
        result[etid].consumers.push(p)
      end
    end

    result.values
  end

  def self.run_connection_type(params)
    result = []
    cl = Community.new name: 'No con. info.',
                     description: 'No connection info.'
    cl.consumers << consumers(params).where(connection_type: nil)
    result.push(cl)

    ConnectionType.all.each do |bt|
      cl = Community.new name: "CL: #{bt.name}",
                       description: "Consumers with #{bt.name} connection."

      cl.consumers << consumers(params).where(connection_type: bt)
      result.push(cl)
    end
    result
  end

  def self.run_building_type(params)
    result = []
    cl = Community.new name: 'No buil. info',
                     description: 'No building type info.'

    cl.consumers << consumers(params).where(building_type: nil)
    result.push(cl)

    BuildingType.all.each do |bt|
      cl = Community.new name: "CL: #{bt.name}",
                       description: "Consumers with #{bt.name} building type."
      cl.consumers << consumers(params).where(building_type: bt)

      result.push(cl)
    end
    Rails.logger.debug "The result is #{result.map(&:consumer_ids)}"

    result
  end

  def self.get_centroid(cluster)
    sum_x = 0
    sum_y = 0
    count = 0
    cluster.consumers.each do |p|
      fail 'Found consumer without location' if p.location_x.nil? ||
                                                p.location_y.nil?
      sum_x += p.location_x
      sum_y += p.location_y
      count += 1
    end
    {
      x: sum_x / count,
      y: sum_y / count,
      cluster: cluster
    }
  end

  def self.get_centroid_dr(cluster, dr_vector)
    {
        dr: cluster.map {|p| dr_vector[p]}.sum / cluster.size,
        cluster: cluster
    }
  end

  def self.distance(consumer, centroid)
    (consumer.location_x - centroid[:x])**2 +
      (consumer.location_y - centroid[:y])**2
  end

  def self.find_closest(consumer, centroids)
    min = Float::MAX
    closest = nil
    centroids.each do |centroid|
      d = distance(consumer, centroid)
      if d < min
        min = d
        closest = centroid[:cluster]
      end
    end
    closest
  end

  def self.find_closest_dr(dr, centroids)
    (centroids.min_by do |c|
      (c[:dr] - dr).abs
    end)[:cluster]
  end

  def self.run_location(params)
    result = consumers(params).with_locations.sample(params[:kappa]).map.with_index do |p, i|
      cl = Community.new name: "Loc: #{i}",
                       description: "Location based cluster #{i}."
      cl.consumers.push p
      cl
    end

    centroids = result.map { |cl| get_centroid(cl) }
    loop do
      old_centroids = Array.new(centroids)
      result.each { |cl| cl.consumers.clear }
      consumers(params).with_locations.each do |p|
        find_closest(p, centroids).consumers.push p
      end
      centroids = result.map { |cl| get_centroid(cl) }
      break if centroids <=> old_centroids
    end

    without_location = consumers(params) - consumers(params).with_locations

    if without_location.count > 0
      cl = Community.new name: 'No loc.',
                       description: 'Consumers with no Location info available.'
      cl.consumers << without_location
      result.push cl
    end
    result
  end
end
