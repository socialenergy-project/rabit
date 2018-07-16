class EccFactor < ApplicationRecord
  belongs_to :ecc_term
  after_destroy :destroy_orphaned_terms

  enum period: [
      :hourly_per_minute,
      :daily_per_15_min,
      :daily_per_hour,
      :weekly_per_day,
      :monthly_per_day,
      :yearly_per_month,
  ]

  validates_presence_of :period

  private
  def destroy_orphaned_terms
    ecc_term.delete if ecc_term&.ecc_factors&.count == 0
  end
end
