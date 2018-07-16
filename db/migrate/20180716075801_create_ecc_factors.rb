class CreateEccFactors < ActiveRecord::Migration[5.1]
  def change
    create_table :ecc_factors do |t|
      t.integer :period
      t.integer :start
      t.integer :stop
      t.references :ecc_term, foreign_key: true

      t.timestamps
    end
  end
end
