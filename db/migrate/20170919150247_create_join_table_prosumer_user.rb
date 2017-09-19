class CreateJoinTableProsumerUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :prosumers, :users do |t|
      # t.index [:prosumer_id, :user_id]
      # t.index [:user_id, :prosumer_id]
    end
  end
end
