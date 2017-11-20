class Clustering < ApplicationRecord
  has_many :communities, dependent: :destroy

  validates_associated :communities, message: ->(_class_obj, obj){ p "community OBJ is ", obj[:value]; obj[:value].map(&:errors).map(&:full_messages).join(',') }

end
