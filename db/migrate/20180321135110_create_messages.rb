class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.references :sender, index: true, foreign_key: { to_table: :users }
      t.references :recipient, index: true, foreign_key: { to_table: :users }
      t.references :recommendation, foreign_key: true

      t.text :content
      t.integer :status

      t.timestamps
    end
  end
end
