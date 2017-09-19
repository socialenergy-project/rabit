class CreateProsumers < ActiveRecord::Migration[5.1]
  def change
    create_table :prosumers do |t|
      t.string :name
      t.string :location
      t.string :edms_id
      t.references :building_type, foreign_key: true
      t.references :connection_type, foreign_key: true
      t.float :location_x
      t.float :location_y
      t.string :feeder_id
      t.references :prosumer_category, foreign_key: true

      t.timestamps
    end
  end
end
