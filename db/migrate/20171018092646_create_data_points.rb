class CreateDataPoints < ActiveRecord::Migration[5.1]
  def change
    create_table :data_points do |t|
      t.references :consumer, foreign_key: true
      t.references :interval, foreign_key: true
      t.datetime :timestamp
      t.float :consumption
      t.float :flexibility

      t.timestamps
    end

    add_index :data_points , [:timestamp, :consumer_id, :interval_id], unique: true

  end
end
