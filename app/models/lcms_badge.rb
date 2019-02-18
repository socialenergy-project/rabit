class LcmsBadge < ApplicationRecord
  belongs_to :user

  def self.get_level(user_id, competence)
    LcmsBadge.where(user_id: user_id, topic: competence)
             .maximum('10 * numeric')
             &.round&.modulo(10) || 0 # Extract decimal from float, https://stackoverflow.com/a/12406126/828193
  end


end
