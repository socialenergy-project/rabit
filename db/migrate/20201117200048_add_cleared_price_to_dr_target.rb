class AddClearedPriceToDrTarget < ActiveRecord::Migration[6.0]
  def change
    add_column :dr_targets, :cleared_price, :decimal 
  end
end
