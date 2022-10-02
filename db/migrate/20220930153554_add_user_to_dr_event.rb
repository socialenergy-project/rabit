class AddUserToDrEvent < ActiveRecord::Migration[6.1]
  def change
    add_reference :dr_events, :user, null: false, foreign_key: true, default: User.find_by(email: "admin@test.com").id
  end
end
