class DrEvent < ApplicationRecord
  belongs_to :interval

  enum state: [ :ready, :active, :completed, :elapsed ]
  enum type: [ :automatic, :manual ]

end
