class AddAdditionalIndexToDataPoints < ActiveRecord::Migration[5.1]
  def change
    add_index :data_points, [:timestamp, :consumer_id]
    add_index :data_points, [:timestamp, :interval_id]
  end
end
