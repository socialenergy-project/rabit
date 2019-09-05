class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group
  enum role: [:ec_leader, :member]
end
