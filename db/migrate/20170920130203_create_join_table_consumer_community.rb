class CreateJoinTableConsumerCommunity < ActiveRecord::Migration[5.1]
  def change
    create_join_table :consumers, :communities do |t|
      t.index [:consumer_id, :community_id]
      t.index [:community_id, :consumer_id]
    end
  end
end
