class AddValueAndPriceToEccTerms < ActiveRecord::Migration[6.0]
  def change
    add_column :ecc_terms, :value, :float
    add_column :ecc_terms, :price_per_mw, :decimal, precision: 15, scale: 2
  end
end
