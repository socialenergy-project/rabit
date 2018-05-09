class AddDefaultStateToRecommendations < ActiveRecord::Migration[5.1]
  def change
    change_column_default :recommendations, :status, from: nil, to: 0
  end
end
