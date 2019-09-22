class AddSecondIndexToDataPoints < ActiveRecord::Migration[5.2]
  def change
    add_index :data_points, [:timestamp, :consumer_id], order: {timestamp: :asc}
    add_index :data_points, [:timestamp, :interval_id], order: {timestamp: :asc}
  end
end
