require 'csv'

namespace :db do
  desc "Create csv files for all database tables"
  task backup_to_initdata: :environment do |t, args|
    puts "My environment is #{Rails.env}"
    # FileUtils.rm_rf(Dir.glob('db/initdata/*'))

    Rails.application.eager_load!

    (args.extras.count > 0 ? args.extras.map(&:constantize) : ActiveRecord::Base.descendants.reject do |t|
      [User, ApplicationRecord].include? t
    end).each do |t|
      CSV.open("db/initdata/#{t}.csv", "wb") do |csv|
        puts "Exporting table: #{t}"
        csv << t.attribute_names
        t.all.order(t.attribute_names.include?("id") ? 'id ASC' : '').each do |row|
          csv << row.attributes.map{|k,v| v.try(:utc) || v}
        end
      end
    end
  end
end