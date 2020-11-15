class CreateDrEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :dr_events do |t|
      t.string :name
      t.datetime :starttime
      t.references :interval, null: false, foreign_key: true
      t.decimal :price
      t.integer :state
      t.integer :type

      t.timestamps
    end
  end
end
