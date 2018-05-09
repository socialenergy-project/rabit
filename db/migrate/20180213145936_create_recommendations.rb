class CreateRecommendations < ActiveRecord::Migration[5.1]
  def change
    create_table :recommendations do |t|
      t.integer :status
      t.references :recommendation_type, foreign_key: true
      t.references :scenario, foreign_key: true
      t.string :parameter

      t.timestamps
    end
  end
end
