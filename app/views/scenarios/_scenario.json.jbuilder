json.extract! scenario, :id, :name, :consumer_ids, :starttime, :endtime, :interval_id, :ecc_type_id, :energy_cost_parameter, :profit_margin_parameter, :flexibility_id, :gamma_parameter, :energy_program_ids, :created_at, :updated_at
if scenario.stderr and @error
  json.errors @error
elsif @plot_data
  json.plot_data @plot_data
end
json.url scenario_url(scenario, format: :json)
