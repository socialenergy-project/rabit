class CreateJoinTableRecommendationsConsumers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :recommendations, :consumers do |t|
      t.index [:recommendation_id, :consumer_id], name: 'rec_cons'
      t.index [:consumer_id, :recommendation_id], name: 'cons_rec'
    end
  end
end
