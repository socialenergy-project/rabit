class CreateJoinTableConsumerClScenario < ActiveRecord::Migration[5.1]
  def change
    create_join_table :consumers, :cl_scenarios do |t|
      t.index [:consumer_id, :cl_scenario_id]
      t.index [:cl_scenario_id, :consumer_id]
    end
  end
end
