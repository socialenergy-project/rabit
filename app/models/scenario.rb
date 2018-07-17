require 'python_wrapper/python_wrapper'

class Scenario < ApplicationRecord
  belongs_to :interval
  belongs_to :ecc_type
  belongs_to :flexibility
  belongs_to :user

  has_and_belongs_to_many :consumers
  has_and_belongs_to_many :energy_programs

  has_many :results, dependent: :destroy

  attr_reader :python_exception

  include Recommendable


  filterrific(
      default_filter_params: { sorted_by: 'created_at_desc' },
      available_filters: [
          :sorted_by,
          :search_query,
          :with_interval_id,
          :with_created_at_gte,
          :with_ecc_type_id,
          :with_user_id,
          :with_starttime,
          :with_endtime,
          :with_energy_cost_parameter,
          :with_profit_margin_parameter,
          :with_flexibility_id,
          :with_number_of_clusters,
          :with_gamma_parameter,
          :with_updated_at,
          :with_created_at,
      ]
  )

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^name_/
      order("LOWER(scenarios.name) #{ direction }")
    when /^user_/
      order("LOWER(users.name) #{ direction }").includes(:user).references(:user)
    when /^description_/
      order("LOWER(scenarios.description) #{ direction }")
    when /^start_time_/
      order("starttime #{ direction }")
    when /^end_time_/
      order("endtime #{ direction }")
    when /^interval_/
      order("intervals.duration #{ direction }").includes(:interval).references(:interval)
    when /^ecc_type_/
      order("ecc_types.name #{ direction }").includes(:ecc_type).references(:ecc_type)
    when /^energy_cost_parameter_/
      order("scenarios.energy_cost_parameter #{ direction }")
    when /^profit_margin_parameter_/
      order("scenarios.profit_margin_parameter #{ direction }")
    when /^flexibility_factor_/
      order("flexibilities.name #{ direction }").includes(:flexibility).references(:flexibility)
    when /^number_of_clusters_/
      order("scenarios.number_of_clusters #{ direction }")
    when /^gamma_parameter_/
      order("scenarios.gamma_parameter #{ direction }")
    when /^created_at_/
      order("scenarios.created_at #{ direction }")
    when /^updated_at_/
      order("scenarios.updated_at #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  scope :search_query, lambda { |query|
    return nil  if query.blank?

    # condition query, parse into individual keywords
    terms = query.to_s.downcase.split(/\s+/)

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 2
    where(
        terms.map { |term|
          "(LOWER(scenarios.name) LIKE ? OR LOWER(scenarios.description) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }

  scope :with_interval_id, lambda { |query|
    where(interval_id: query)
  }

  scope :with_ecc_type_id, lambda { |query|
    where(ecc_type_id: query)
  }

  scope :with_user_id, lambda { |query|
    where(user_id: query)
  }

  scope :with_starttime, lambda { |query|
    higher_lower_or_in_between(:starttime,
                               query[:after]&.to_datetime,
                               query[:before]&.to_datetime)
  }

  scope :with_endtime, lambda { |query|
    higher_lower_or_in_between(:endtime,
                               query[:after]&.to_datetime,
                               query[:before]&.to_datetime)
  }

  scope :with_energy_cost_parameter, lambda { |query|
    higher_lower_or_in_between(:energy_cost_parameter,
                               query[:above],
                               query[:below])
  }

  scope :with_profit_margin_parameter, lambda { |query|
    higher_lower_or_in_between(:profit_margin_parameter,
                               query[:above],
                               query[:below])
  }

  scope :with_flexibility_id, lambda { |query|
    where(flexibility_id: query)
  }

  scope :with_number_of_clusters, lambda { |query|
    higher_lower_or_in_between(:number_of_clusters,
                               query[:above],
                               query[:below])
  }
  scope :with_gamma_parameter, lambda { |query|
    higher_lower_or_in_between(:gamma_parameter,
                               query[:above],
                               query[:below])
  }

  scope :with_updated_at, lambda { |query|
    higher_lower_or_in_between(:updated_at,
                               query[:after]&.to_datetime,
                               query[:before]&.to_datetime)
  }

  scope :with_created_at, lambda { |query|
    higher_lower_or_in_between(:created_at,
                               query[:after]&.to_datetime,
                               query[:before]&.to_datetime)
  }

  def self.higher_lower_or_in_between(field, lower_bound, upper_bound)
    if not lower_bound.blank? and not upper_bound.blank?
      where( field => lower_bound .. upper_bound)
    elsif not lower_bound.blank? and upper_bound.blank?
      where("#{field} >= :lower_bound", lower_bound: lower_bound)
    elsif not upper_bound.blank? and lower_bound.blank?
      where("#{field} <= :upper_bound", upper_bound: upper_bound)
    end
  end

  after_commit on: [:create, :update] do
    transaction do
      self.results&.delete_all
      self.update_columns stderr: nil, error_message: nil
      begin
        valid_timestamps = self.ecc_type.get_valid_timestamps(self.interval.timestamps(self.starttime, self.endtime))

        result = PythonWrapper.run_pricing({"consumer_ids": self.consumers.map.with_index{|c,i| (i+1).to_s}, #   ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"],
                                            "consumers_data": self.consumers.map.with_index do |c,i|
                                              [(i+1).to_s, [c.data_points.where(
                                                  interval: self.interval,
                                                  timestamp: valid_timestamps
                                              ).order(timestamp: :asc).pluck(:consumption).map{|v| v == 0 ? 0.0001 : v}  ]]
                                            end.to_h,
                                            "number_of_runs": valid_timestamps.count,
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
                timestamp: valid_timestamps[offset],
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
