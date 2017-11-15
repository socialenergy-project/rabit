class AddStderrToScenarios < ActiveRecord::Migration[5.1]
  def change
    add_column :scenarios, :stderr, :text, limit: 1048576
  end
end
