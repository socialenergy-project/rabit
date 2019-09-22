class CreateSmartPlugs < ActiveRecord::Migration[5.2]
  def change
    create_table :smart_plugs do |t|
      t.references :consumer, foreign_key: true
      t.string :name
      t.string :mqtt_name

      t.timestamps
    end
  end
end
