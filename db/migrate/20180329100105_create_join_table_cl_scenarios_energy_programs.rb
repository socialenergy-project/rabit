class CreateJoinTableClScenariosEnergyPrograms < ActiveRecord::Migration[5.1]
  def change
    create_join_table :cl_scenarios, :energy_programs do |t|
      t.index [:cl_scenario_id, :energy_program_id], name: 'index_cl_scen_ep'
      t.index [:energy_program_id, :cl_scenario_id], name: 'index_ep_cl_scen'
    end
  end
end
