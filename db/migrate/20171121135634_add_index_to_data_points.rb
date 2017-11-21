class AddIndexToDataPoints < ActiveRecord::Migration[5.1]
  def change
    add_index :data_points, :timestamp
  end
end
