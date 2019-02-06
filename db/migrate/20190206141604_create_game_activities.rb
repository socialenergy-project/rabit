class CreateGameActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :game_activities do |t|
      t.integer :totalScore
      t.references :user, foreign_key: true
      t.integer :dailyScore
      t.integer :gameDuration
      t.datetime :timestampUserLoggediIn
      t.string :energyProgram
      t.string :levelGame

      t.timestamps
    end
    add_index :game_activities, [:user_id, :timestampUserLoggediIn, :totalScore, :dailyScore, :gameDuration,
                                 :energyProgram, :levelGame], unique: true,  name: :game_act_uniq

  end
end
