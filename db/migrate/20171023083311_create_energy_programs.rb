class CreateEnergyPrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :energy_programs do |t|
      t.string :name

      t.timestamps
    end
  end
end
