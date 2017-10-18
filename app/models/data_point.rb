class DataPoint < ApplicationRecord
  belongs_to :consumer
  belongs_to :interval
end
