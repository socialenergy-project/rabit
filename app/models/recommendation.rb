class Recommendation < ApplicationRecord
  belongs_to :recommendation_type
  belongs_to :recommendable, polymorphic: true, required: false

  enum status: [:created, :sent, :notified]

  has_and_belongs_to_many :consumers
  has_and_belongs_to_many :users
  has_many :messages, dependent: :restrict_with_exception


  def draft_messages
    consumers.map do |c|
      c.users.map do |u|
        {
            recipient: u,
            message: draft_single(c)
        }
      end
    end.flatten + users.map do |u|
      {
          recipient: u,
          message: draft_single(nil)
      }
    end
  end

  validate :dont_change_when_there_are_messages

  private

  def draft_single(consumer)
    return custom_message % [consumer&.name, parameter] unless custom_message.blank?

    case recommendation_type.name
    when 'Switch Energy Program'
      initial_cost = recommendable.results.where(energy_program_id: EnergyProgram.find_by(name: 'RTP (no DR)')).sum(:energy_cost)
      new_cost = recommendable.results.where(energy_program_id: EnergyProgram.find_by(name: parameter)).sum(:energy_cost)
      recommendation_type.description % [consumer&.name, parameter] + ' Estimated cost reduction of about %d%%.' % (100 *(initial_cost - new_cost) / initial_cost)
    when 'Engagement', 'Congradulate'
      recommendation_type.description % parameter
    else
      recommendation_type.description % [consumer&.name, parameter]
    end

  end

  def dont_change_when_there_are_messages
    if messages.count > 0
      errors.add(:recommendation_id, "Cannot modify recommendation with active messages")
    end
  end
end
