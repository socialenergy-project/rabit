class DrPlanAction < ApplicationRecord
  belongs_to :dr_target
  belongs_to :consumer
end
