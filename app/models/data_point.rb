class DataPoint < ApplicationRecord
  belongs_to :consumer
  belongs_to :interval

  def name
    [self.consumer.name, self.interval.name, self.timestamp.to_s].join(", ")
  end
end
