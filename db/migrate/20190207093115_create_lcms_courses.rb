class CreateLcmsCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :lcms_courses do |t|
      t.string :topic
      t.string :level
      t.float :numeric
      t.references :user, foreign_key: true
      t.datetime :graded_at
      t.float :current_grade
      t.integer :time_spent_seconds
      t.float :grade_min
      t.float :grade_max
      t.float :grade_pass

      t.timestamps
    end

    add_index :lcms_courses, [:user_id, :topic, :level, :numeric, :graded_at,
                              :current_grade, :grade_min,
                              :grade_max],
              unique: true,  name: :lcms_courses_uniq

  end
end
