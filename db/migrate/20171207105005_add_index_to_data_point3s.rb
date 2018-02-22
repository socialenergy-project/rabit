class AddIndexToDataPoint3s < ActiveRecord::Migration[5.1]
  def change
    add_index :data_points, [:timestamp, :interval_id]
  end
end
