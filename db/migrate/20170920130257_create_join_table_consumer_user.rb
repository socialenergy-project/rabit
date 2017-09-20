class CreateJoinTableConsumerUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :consumers, :users do |t|
      # t.index [:consumer_id, :user_id]
      # t.index [:user_id, :consumer_id]
    end
  end
end
