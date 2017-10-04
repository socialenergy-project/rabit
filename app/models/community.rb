class Community < ApplicationRecord
  belongs_to :clustering
  has_and_belongs_to_many :consumers

end
