# frozen_string_literal: true

class ChangeVolumeColumnToDecimal < ActiveRecord::Migration[6.0]
  def change
    change_column :ecc_terms, :value, :decimal, precision: 15, scale: 4
  end
end
