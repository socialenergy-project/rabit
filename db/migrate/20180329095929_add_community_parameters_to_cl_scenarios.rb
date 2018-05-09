class AddCommunityParametersToClScenarios < ActiveRecord::Migration[5.1]
  def change
    add_column :cl_scenarios, :cost_parameter, :float
    add_reference :cl_scenarios, :flexibility, foreign_key: true
  end
end
