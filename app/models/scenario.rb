require 'python_wrapper/python_wrapper'

class Scenario < ApplicationRecord
  belongs_to :interval
  belongs_to :ecc_type
  belongs_to :flexibility
  belongs_to :user

  has_and_belongs_to_many :consumers
  has_and_belongs_to_many :energy_programs
  has_many :recommendations, dependent: :nullify

  has_many :results, dependent: :destroy

  attr_reader :python_exception

  after_commit on: [:create, :update] do
    transaction do
      self.results&.delete_all
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
                                            "cost": self.energy_cost_parameter,
                                            "profit": self.profit_margin_parameter,
                                            "weight_flexibility": 0.9,
                                            "weight_friendship": 0.1,
                                            "max_pressure":0.15,
                                            "select_algorithm": self.energy_programs,
                                            "level_flexibility": self.flexibility.id,
                                            "number_of_clusters": self.number_of_clusters,
                                            "pp_enable": 0.0}, 'crtp_prtp_rtp')

        puts JSON.pretty_generate result

        Result.create!(result.map do |energy_program, algo_res|
          algo_res.map.with_index do |res, offset|
            # puts res['AUWF']
            {
                scenario: self,
                timestamp: self.starttime + self.interval.duration * offset,
                energy_program_id: energy_program.id,
                energy_cost: res['Cost'],
                user_welfare: res['AUWF'],
                retailer_profit: res['Profits'],
                total_bill: res['Bills'],
                total_consumption: res['Consumptions'],
            }
          end
        end.flatten)

      rescue PythonError => e
        self.update_columns stderr: e.stderr, error_message: e.msg
      end
    end
  end

  def best_energy_program
    best = self.results.group(:energy_program_id).sum(:user_welfare).max{|r| r[1]}
    if best
      EnergyProgram.find(best[0])
    end
  end
end
