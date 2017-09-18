class CreateProsumerCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :prosumer_categories do |t|
      t.string :name
      t.text :description
      t.boolean :real_time

      t.timestamps
    end
  end
end
