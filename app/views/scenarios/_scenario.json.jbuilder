json.extract! scenario, :id, :name, :starttime, :endtime, :interval_id, :ecc_type_id, :energy_cost_parameter, :profit_margin_parameter, :flexibility_id, :gamma_parameter, :created_at, :updated_at
if @scenario.stderr
  json.errors @error
else
  json.plot_data @plot_data
end
json.url scenario_url(scenario, format: :json)
