class AddEnergyProgramToConsumers < ActiveRecord::Migration[5.1]
  def change
    add_reference :consumers, :energy_program, foreign_key: true
  end
end
