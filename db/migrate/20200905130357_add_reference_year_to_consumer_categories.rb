class AddReferenceYearToConsumerCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :consumer_categories, :reference_year, :integer
  end
end
