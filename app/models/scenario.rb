class Scenario < ApplicationRecord
  belongs_to :interval
  belongs_to :ecc_type

  has_and_belongs_to_many :consumers
  has_and_belongs_to_many :energy_programs
end
