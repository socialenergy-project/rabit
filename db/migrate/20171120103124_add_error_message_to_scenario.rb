class AddErrorMessageToScenario < ActiveRecord::Migration[5.1]
  def change
    add_column :scenarios, :error_message, :string
  end
end
