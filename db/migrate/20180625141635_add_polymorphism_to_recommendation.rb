class AddPolymorphismToRecommendation < ActiveRecord::Migration[5.1]
  def change
    rename_column :recommendations, :scenario_id, :recommendable_id
    add_column :recommendations, :recommendable_type, :string

    Recommendation.update_all(recommendable_type: 'Scenario')
  end
end
