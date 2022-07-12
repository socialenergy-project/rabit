require 'csv'

namespace :db do
  desc "Create csv files for all database tables"
  task backup_to_initdata: :environment do |t, args|
    puts "My environment is #{Rails.env}"
    # FileUtils.rm_rf(Dir.glob('db/initdata/*'))

    Rails.application.eager_load!

    (args.extras.count > 0 ? args.extras.map(&:constantize) : ActiveRecord::Base.descendants.reject do |t|
      [User, ApplicationRecord, DataPoint].include? t
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


  task restore_from_initdata: :environment do |t, args|
    puts "My environment is #{Rails.env}"
    # FileUtils.rm_rf(Dir.glob('db/initdata/*'))

    Rails.application.eager_load!

    (args.extras.count > 0 ? args.extras.map(&:constantize) : ActiveRecord::Base.descendants.reject do |t|
      [User, ApplicationRecord].include? t
    end).each do |t|

      dbconn = ActiveRecord::Base.connection_pool.checkout
      raw  = dbconn.raw_connection

      Zlib::GzipReader.open("db/initdata/#{t}.csv.gz") do |gz|
        begin
          CSV.new(gz.read, :headers => true).each do |row|
            t.where(id: row['id']).first_or_initialize.tap do |cc|
              cc.update_attributes(row.to_h)
              # yield(cc) if block_given?
              cc.save!
            end
          end
          dbconn.reset_pk_sequence!(t.table_name)
        rescue Exception => e
          puts "Error during processing: #{$!}"
          puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        ensure
          dbconn.close
        end
        puts "Created #{t.all.count} #{t.table_name.pluralize}"
      end
    end
  end
end
