class CreateUserClusteringParameters < ActiveRecord::Migration[5.1]
  def change
    create_table :user_clustering_parameters do |t|
      t.references :user_clustering_scenario, foreign_key: true
      t.references :user, foreign_key: true
      t.string :paramtype
      t.float :value

      t.timestamps
    end
  end
end
