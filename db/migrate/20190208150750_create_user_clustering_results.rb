class CreateUserClusteringResults < ActiveRecord::Migration[5.1]
  def change
    create_table :user_clustering_results do |t|
      t.references :user_clustering_scenario, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :cluster

      t.timestamps
    end
  end
end
