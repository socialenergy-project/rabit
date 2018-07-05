class RemoveForeignKeyFromScenarios < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :recommendations, :scenarios
  end
end
