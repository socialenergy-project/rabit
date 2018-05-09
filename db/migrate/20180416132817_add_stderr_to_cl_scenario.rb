class AddStderrToClScenario < ActiveRecord::Migration[5.1]
  def change
    add_column :cl_scenarios, :stderr, :text
    add_column :cl_scenarios, :error_message, :string
  end
end
