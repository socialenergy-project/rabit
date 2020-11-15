class CreateDrTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :dr_targets do |t|
      t.references :dr_event, null: false, foreign_key: true
      t.integer :ts_offset
      t.decimal :volume

      t.timestamps
    end

    add_index :dr_targets, [ :dr_event_id, :ts_offset ], unique: true
  end
end
