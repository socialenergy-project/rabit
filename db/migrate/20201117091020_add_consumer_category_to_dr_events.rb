class AddConsumerCategoryToDrEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference :dr_events, :consumer_category, null: true, foreign_key: true
  end
end
