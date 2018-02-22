class AddIndexToDataPoints2 < ActiveRecord::Migration[5.1]
  def change
    add_index :data_points, [:timestamp, :consumer_id]
  end
end
