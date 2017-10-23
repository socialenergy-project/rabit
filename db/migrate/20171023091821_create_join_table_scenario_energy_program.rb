class CreateJoinTableScenarioEnergyProgram < ActiveRecord::Migration[5.1]
  def change
    create_join_table :scenarios, :energy_programs do |t|
      t.index [:scenario_id, :energy_program_id], unique: true, name: 'index_scenario_energy_program'
      t.index [:energy_program_id, :scenario_id], unique: true, name: 'index_energy_program_scenario'
    end
  end
end
