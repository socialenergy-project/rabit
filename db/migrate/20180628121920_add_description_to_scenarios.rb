class AddDescriptionToScenarios < ActiveRecord::Migration[5.1]
  def change
    add_column :scenarios, :description, :text
  end
end
