json.extract! ecc_type, :id, :name, :ramp_up_rate, :ramp_down_rate, :max_activation_time_per_activation, :max_activation_time_per_day, :energy_up_per_day, :energy_down_per_day, :minimum_activation_time, :max_activations_per_day, :created_at, :updated_at
json.url ecc_type_url(ecc_type, format: :json)
