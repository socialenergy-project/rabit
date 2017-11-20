class AddUserToScenario < ActiveRecord::Migration[5.1]
  def change
    add_reference :scenarios, :user, foreign_key: true
  end
end
