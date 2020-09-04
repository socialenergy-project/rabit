class AddIndexToConsumers < ActiveRecord::Migration[6.0]
  def change
    add_index :consumers, :edms_id, unique: true
  end
end
