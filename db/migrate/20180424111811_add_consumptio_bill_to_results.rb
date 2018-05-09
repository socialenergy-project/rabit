class AddConsumptioBillToResults < ActiveRecord::Migration[5.1]
  def change
    add_column :results, :total_consumption, :float
    add_column :results, :total_bill, :float
  end
end
