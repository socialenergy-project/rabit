class CreateJoinTableUserRecommenation < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :recommendations do |t|
      t.index [:user_id, :recommendation_id]
      t.index [:recommendation_id, :user_id]
    end
  end
end
