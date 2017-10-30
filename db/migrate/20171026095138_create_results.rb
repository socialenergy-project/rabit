class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.references :scenario, foreign_key: true
      t.references :energy_program, foreign_key: true
      t.datetime :timestamp
      t.float :energy_cost
      t.float :user_welfare
      t.float :retailer_profit

      t.timestamps
    end
  end
end
