class AddGsrnStatusToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :gsrn_status, :integer, default: 0
  end
end
