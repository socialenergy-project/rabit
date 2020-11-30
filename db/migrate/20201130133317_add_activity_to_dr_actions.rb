class AddActivityToDrActions < ActiveRecord::Migration[6.0]
  def change
    add_column :dr_actions, :activated_at, :datetime
    add_column :dr_actions, :deactivated_at, :datetime
  end
end
