# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Interval.where(duration: 900).first_or_initialize.tap do |interval|
  interval.name = "15 minutes"
  interval.id = 1
  interval.save!
end

Interval.where(duration: 3600).first_or_initialize.tap do |interval|
  interval.name = "1 hour"
  interval.id = 2
  interval.save!
end

Interval.where(duration: 86400).first_or_initialize.tap do |interval|
  interval.name = "Daily"
  interval.id = 3
  interval.save!
end

RecommendationType.where(id: 1).first_or_initialize.tap do |recommendation_type|
  recommendation_type.name = "Switch Energy Program"
  recommendation_type.description = "Our algorithm has determined that you should switch your energy program " \
                                    "at consumer %s. We recommend switching to program %s"
  recommendation_type.save!
end


puts "Created #{Interval.all.count} intervals"


def initialize_with_id_and_name(hash, model)
  puts "Hash is #{hash}, model is #{model}"
  hash.each do |k,v|
    model.where(name: v).first_or_initialize.tap do |cc|
      cc.id = k
      yield(cc) if block_given?
      cc.save!
    end
  end
end

initialize_with_id_and_name({ 1 => "By building type", 2 => "CTI" }, Clustering)
puts "Created #{Clustering.all.count} clusterings"

initialize_with_id_and_name({ 1 => "Hedno", 2 => "CTI" }, ConsumerCategory)
puts "Created #{ConsumerCategory.all.count} consumer categories"

initialize_with_id_and_name({
                              1   => "CTI community",
                              100 => "Hedno industrial MV",
                              101 => "Hedno industrial LV",
                              102 => "Hedno commercial MV",
                              103 => "Hedno professional",
                              104 => "Hedno public lighting",
                              105 => "Hedno Residential",
                            }, Community) do |community|
  community.clustering_id = 1
end
initialize_with_id_and_name({
                                1   => "CTI community",
                            }, Community) do |community|
  community.clustering_id = 2
end


puts "Created #{Community.all.count} Communities"

initialize_with_id_and_name({
                                1 => "Industrial",
                                2 => "Commercial",
                                3 => "Proffessional",
                                4 => "Public lighting",
                                5 => "Residential",
                            }, BuildingType)
puts "Created #{BuildingType.all.count} Building types"

initialize_with_id_and_name({
                                1 => "Night hours",
                                2 => "Weekend",
                                3 => "Mon-Fri",
                                4 => "Peak hours",
                            }, EccType)
puts "Created #{EccType.all.count} ECC types"

initialize_with_id_and_name({
                                1 => "RTP (no DR)",
                                2 => "Time of Usage",
                                3 => "Real-time pricing",
                                4 => "Personal Real-time pricing",
                                5 => "Community Real-time pricing",
                            }, EnergyProgram)
puts "Created #{EnergyProgram.all.count} Energy Programs"

initialize_with_id_and_name({
                                1 => "Custom",
                                2 => "Low",
                                3 => "Medium",
                                4 => "High",
                            }, Flexibility)
puts "Created #{Flexibility.all.count} Flexibilities"


# ["Consumer", "Community::HABTM_Consumers", "DataPoint"].each do |tbl_name|
["Consumer", "Community::HABTM_Consumers"].each do |tbl_name|
  dbconn = ActiveRecord::Base.connection_pool.checkout
  raw  = dbconn.raw_connection
  begin
    file = File.new "db/initdata/#{tbl_name}.csv"        # open a compressed file
    dbconn.disable_referential_integrity do
      if tbl_name == "Community::HABTM_Consumers"
        tbl_name.constantize.where(community_id: [1,100 .. 105]).delete_all
      else
        tbl_name.constantize.delete_all
      end
      raw.copy_data "COPY #{tbl_name.constantize.table_name} (#{file.gets}) FROM stdin DELIMITER ',' CSV;" do
        puts "Loading #{tbl_name}..."
        progressbar = ProgressBar.create starting_at: 1, total: %x{wc -l "db/initdata/#{tbl_name}.csv"}.split.first.to_i
        while line=file.gets
          raw.put_copy_data(line)
          progressbar.increment
        end
      end
    end
    dbconn.reset_pk_sequence!(tbl_name.constantize.table_name)
  rescue Exception => e
    puts "Error during processing: #{$!}"
    puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
  ensure
    dbconn.close
  end
  puts "Created #{tbl_name.constantize.all.count} #{tbl_name.pluralize}"
end

ActiveRecord::Base.connection_pool.with_connection do |dbconn|
  ActiveRecord::Base.descendants do |t|
    dbconn.checkout.reset_pk_sequence!(t.table_name)
  end
end

