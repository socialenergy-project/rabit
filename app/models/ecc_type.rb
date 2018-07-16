class EccType < ApplicationRecord
  has_many :scenarios, dependent: :nullify

  has_many :ecc_terms, dependent: :destroy

  accepts_nested_attributes_for :ecc_terms,
                                allow_destroy: true,
                                reject_if: :all_empty1

  private

  def all_empty1(attributes)
    ! attributes[:ecc_factors_attributes]&.any? {|k1,v1| v1.any? {|k2,v2| ! v2.blank? }}
  end

end
