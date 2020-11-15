class RenameTypeinDrEvents < ActiveRecord::Migration[6.0]
  def change
    rename_column :dr_events, :type, :dr_type
  end
end
