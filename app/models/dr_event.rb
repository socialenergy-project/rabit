class DrEvent < ApplicationRecord
  belongs_to :interval
  has_many :dr_targets, dependent: :destroy

  enum state: %i[created ready active completed elapsed]
  enum dr_type: %i[automatic manual]

  accepts_nested_attributes_for :dr_targets,
                                allow_destroy: true,
                                reject_if: ->(attr) { attr['volume'].blank? }
end
