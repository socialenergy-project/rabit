class AddNameToUserClusteringScenarios < ActiveRecord::Migration[5.1]
  def change
    add_column :user_clustering_scenarios, :name, :string
  end
end
