class AddMoreFieldsToSla < ActiveRecord::Migration[6.0]
  def change
    add_column :ecc_types, :ramp_up_rate, :decimal, precision: 15, scale: 4
    add_column :ecc_types, :ramp_down_rate, :decimal, precision: 15, scale: 4
    add_column :ecc_types, :max_activation_time_per_activation, :interval
    add_column :ecc_types, :max_activation_time_per_day, :interval
    add_column :ecc_types, :energy_up_per_day, :decimal, precision: 15, scale: 4
    add_column :ecc_types, :energy_down_per_day, :decimal, precision: 15, scale: 4
    add_column :ecc_types, :minimum_activation_time, :interval
    add_column :ecc_types, :max_activations_per_day, :integer
  end
end
