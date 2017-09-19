class CreateJoinTableProsumerCluster < ActiveRecord::Migration[5.1]
  def change
    create_join_table :prosumers, :clusters do |t|
      t.index [:prosumer_id, :cluster_id]
      t.index [:cluster_id, :prosumer_id]
    end
  end
end
