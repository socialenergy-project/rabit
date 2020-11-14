require 'python_wrapper/python_wrapper'

class ClScenario < ApplicationRecord
  belongs_to :interval
  belongs_to :clustering, optional: true
  belongs_to :user
  belongs_to :flexibility

  has_and_belongs_to_many :consumers
  has_and_belongs_to_many :energy_programs


  validate :dont_change_when_there_are_communities_with_messages

  validates :kappa, :numericality => { :greater_than_or_equal_to => 1 }


  private

  def dont_change_when_there_are_communities_with_messages
    if clustering&.communities and clustering&.communities&.sum{|c| c.recommendations.count } > 0
      errors.add(:recommendation_id, "Cannot modify scenarios with active recommendations")
    end
  end

  after_commit do
    transaction do

      logger.debug "Current clustering is #{clustering&.id}"
      c = clustering
      logger.debug "Current clustering is #{c&.id}"
      c ||= Clustering.new
      logger.debug "New clustering is #{c&.id}"
      c.name = "Auto #{algorithm} - #{name}"
      c.description = "Automatic cluster generated with #{algorithm} algorithm."

      c.communities&.destroy_all

      if algorithm != "crtp"
        c.communities = ClusteringModule.run_algorithm  start_date:  starttime,
                                                        end_date:    endtime,
                                                        interval_id: interval_id,
                                                        algorithm: algorithm,
                                                        kappa: kappa,
                                                        consumer_ids: consumer_ids.reject{|c| c.data_points.where(interval_id: interval_id, timestamp: starttime .. endtime).count == 0},
                                                        cost_parameter: cost_parameter

        c.save(:validate => false)
        self.update_columns(clustering_id: c.id)

      else
        self.update_columns stderr: nil, error_message: nil
        begin
          result = PythonWrapper.run_pricing({"consumer_ids": self.consumers.map.with_index{|c,i| (i+1).to_s}, #   ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"],
                                    "consumers_data": self.consumers.map.with_index do |c,i|
                                      [(i+1).to_s, [c.data_points.where(
                                          interval: self.interval,
                                          timestamp: self.starttime .. self.endtime
                                      ).order(timestamp: :asc).pluck(:consumption).map{|v| v == 0 ? 0.0001 : v}  ]]
                                    end.to_h,
                                    "number_of_runs": self.interval.timestamps(self.starttime, self.endtime).count,
                                    "cost": self.cost_parameter,
                                    "profit":0.0,
                                    "weight_flexibility": 0.9,
                                    "weight_friendship": 0.1,
                                    "max_pressure":0.15,
                                    "select_algorithm": EnergyProgram.where(id: 5).to_a,
                                    "level_flexibility": self.flexibility.id,
                                    "number_of_clusters": self.kappa,
                                    "pp_enable": 0.0}, 'crtp_prtp_rtp')

          p "The result of the algorithm is ", result

          unless result&.first and result&.first[1]&.first and result&.first[1]&.first['Clusters']
            raise PythonError.new("No clusters in result")
          end

          c.communities = result&.first[1].first['Clusters'].map do |name, members|
            Community.new name: "CRTP-#{name}",
                          consumers: members.map{|c| self.consumers[c.to_i - 1]}
          end

          c.save(:validate => false)
          self.update_columns(clustering_id: c.id)
        rescue PythonError => e
          self.update_columns stderr: e.stderr, error_message: e.msg
        end

      end
    end
  end

end
