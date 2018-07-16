class CreateEccTerms < ActiveRecord::Migration[5.1]
  def change
    create_table :ecc_terms do |t|
      t.references :ecc_type, foreign_key: true

      t.timestamps
    end
  end
end
