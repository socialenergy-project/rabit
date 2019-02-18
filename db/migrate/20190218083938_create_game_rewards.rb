class CreateGameRewards < ActiveRecord::Migration[5.1]
  def change
    create_table :game_rewards do |t|
      t.integer :total_credits
      t.integer :total_cash
      t.integer :total_ex_points
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :game_rewards, [:user_id, :total_credits, :total_cash, :total_ex_points],
              unique: true,  name: :game_rewards_uniq
 end
end
