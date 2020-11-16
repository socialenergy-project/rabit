class CreateDrActions < ActiveRecord::Migration[6.0]
  def change
    create_table :dr_actions do |t|
      t.references :dr_target, null: false, foreign_key: true
      t.references :consumer, null: false, foreign_key: true
      t.decimal :volume_planned
      t.decimal :volume_actual
      t.decimal :price_per_mw

      t.timestamps
    end
  end
end
