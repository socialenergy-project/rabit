class CreateUserClusteringScenarios < ActiveRecord::Migration[5.1]
  def change
    create_table :user_clustering_scenarios do |t|
      t.integer :kappa
      t.float :silhouette

      t.timestamps
    end
  end
end
