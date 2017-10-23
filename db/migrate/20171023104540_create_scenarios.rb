class CreateScenarios < ActiveRecord::Migration[5.1]
  def change
    create_table :scenarios do |t|
      t.string :name
      t.datetime :starttime
      t.datetime :endtime
      t.references :interval, foreign_key: true
      t.references :ecc_type, foreign_key: true
      t.float :energy_cost_parameter
      t.float :profit_margin_parameter
      t.float :flexibility_factor
      t.float :gamma_parameter

      t.timestamps
    end
  end
end
