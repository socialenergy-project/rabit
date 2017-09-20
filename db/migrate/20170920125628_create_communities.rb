class CreateCommunities < ActiveRecord::Migration[5.1]
  def change
    create_table :communities do |t|
      t.string :name
      t.text :description
      t.references :clustering, foreign_key: true

      t.timestamps
    end
  end
end
