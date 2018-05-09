class AddNumerOfClustersToScenarios < ActiveRecord::Migration[5.1]
  def change
    add_column :scenarios, :number_of_clusters, :integer
  end
end
