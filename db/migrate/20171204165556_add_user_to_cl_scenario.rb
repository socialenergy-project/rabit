class AddUserToClScenario < ActiveRecord::Migration[5.1]
  def change
    add_reference :cl_scenarios, :user, foreign_key: true
  end
end
