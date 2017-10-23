class CreateJoinTableScenarioConsumer < ActiveRecord::Migration[5.1]
  def change
    create_join_table :scenarios, :consumers do |t|
      t.index [:scenario_id, :consumer_id], unique: true
      t.index [:consumer_id, :scenario_id], unique: true
    end
  end
end
