class Scenario < ApplicationRecord
  belongs_to :interval
  belongs_to :ecc_type

  has_and_belongs_to_many :consumers
  has_and_belongs_to_many :energy_programs

  has_many :results

  after_commit do
    self.results&.destroy_all
    Result.create!(self.interval.timestamps(self.starttime, self.endtime).map do |dt|
      {
          scenario: self,
          timestamp: dt,
          energy_cost: rand * 10.0,
          user_welfare: rand * 10.0,
          retailer_profit: rand * 10.0,
      }
    end)
    puts "Something was committed."
  end
end
