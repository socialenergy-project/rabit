class CreateClScenarios < ActiveRecord::Migration[5.1]
  def change
    create_table :cl_scenarios do |t|
      t.string :name
      t.string :algorithm
      t.integer :kappa
      t.datetime :starttime
      t.datetime :endtime
      t.references :interval, foreign_key: true
      t.references :clustering, foreign_key: true

      t.timestamps
    end
  end
end
