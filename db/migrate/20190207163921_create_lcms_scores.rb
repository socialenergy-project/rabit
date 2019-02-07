class CreateLcmsScores < ActiveRecord::Migration[5.1]
  def change
    create_table :lcms_scores do |t|
      t.integer :competence
      t.float :current_score
      t.float :last_week_score
      t.float :last_month_score
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :lcms_scores, [:user_id, :competence, :current_score,
                             :last_week_score, :last_month_score], 
              unique: true,  name: :lcms_scores_uniq


  end
end
