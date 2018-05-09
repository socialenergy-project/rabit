class Message < ApplicationRecord
  belongs_to :recommendation, optional: true
  belongs_to :sender, class_name: 'User', optional: true
  belongs_to :recipient, class_name: 'User'

  enum status: [:created, :sent, :notified, :read]

end
