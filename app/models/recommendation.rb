class Recommendation < ApplicationRecord
  belongs_to :recommendation_type
  belongs_to :recommendable, polymorphic: true, required: false

  enum status: [:created, :sent, :notified]

  has_and_belongs_to_many :consumers
  has_many :messages

  def draft_messages
    consumers.map do |c|
      c.users.map do |u|
        {
            recipient: u,
            message: (custom_message.blank? ? recommendation_type.description : custom_message) % [c.name, parameter]
        }
      end
    end.flatten
  end

  validate :dont_change_when_there_are_messages

  private

  def dont_change_when_there_are_messages
    if messages.count > 0
      errors.add(:recommendation_id, "Cannot modify recommendation with active messages")
    end
  end
end
