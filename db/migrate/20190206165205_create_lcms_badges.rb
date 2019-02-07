class CreateLcmsBadges < ActiveRecord::Migration[5.1]
  def change
    create_table :lcms_badges do |t|
      t.string :topic
      t.string :level
      t.float :numeric
      t.references :user, foreign_key: true
      t.date :date_given

      t.timestamps
    end

    add_index :lcms_badges, [:user_id, :topic, :level, :numeric, :date_given],
              unique: true,  name: :lcms_badge_uniq

  end
end
