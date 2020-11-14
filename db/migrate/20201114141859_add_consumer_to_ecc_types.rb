class AddConsumerToEccTypes < ActiveRecord::Migration[6.0]
  def change
    add_reference :ecc_types, :consumer, null: true, foreign_key: true
  end
end
