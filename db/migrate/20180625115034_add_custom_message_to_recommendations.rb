class AddCustomMessageToRecommendations < ActiveRecord::Migration[5.1]
  def change
    add_column :recommendations, :custom_message, :text
  end
end
