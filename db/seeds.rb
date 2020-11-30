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

Interval.where(duration: 300).first_or_initialize.tap do |interval|
  interval.name = "5 minutes"
  interval.id = 4
  interval.save!
end

Interval.where(duration: 60).first_or_initialize.tap do |interval|
  interval.name = "1 minute"
  interval.id = 5
  interval.save!
end

puts "Created #{Interval.all.count} intervals"

RecommendationType.where(id: 1).first_or_initialize.tap do |recommendation_type|
  recommendation_type.name = "Switch Energy Program"
  recommendation_type.description = "Our algorithm has determined that you should switch your energy program " \
                                    "at consumer %s. We recommend switching to program %s"
  recommendation_type.save!
end

RecommendationType.where(id: 2).first_or_initialize.tap do |recommendation_type|
  recommendation_type.name = "Demand Response Event"
  recommendation_type.description = "Please reduce your energy consumption at consumer %s in the time period %s, by as much as possible."
  recommendation_type.save!
end

RecommendationType.where(id: 3).first_or_initialize.tap do |recommendation_type|
  recommendation_type.name = "Engagement"
  recommendation_type.description = "Tip: get GSRN credits by improving your following metrics: %s."
  recommendation_type.save!
end

RecommendationType.where(id: 4).first_or_initialize.tap do |recommendation_type|
  recommendation_type.name = "Congradulate"
  recommendation_type.description = "Tip: congardulations, you are one of the best performing users by the following metrics: %s."
  recommendation_type.save!
end

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

initialize_with_id_and_name({ 1 => "By building type", 2 => "ICCS", 3 => "compare energy and power", 4=> "Protergeia", 5=> "Flexgrid" }, Clustering)
puts "Created #{Clustering.all.count} clusterings"

initialize_with_id_and_name({ 1 => "Hedno", 2 => "ICCS", 3 => "Protergeia", 4 => "Flexgrid" }, ConsumerCategory)

ConsumerCategory.find(1).update reference_year: 2015
ConsumerCategory.find(4).update reference_year: 2018

puts "Created #{ConsumerCategory.all.count} consumer categories"

initialize_with_id_and_name({
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
                                1 => "ICCS community (kwh by power sensor)",
                                2 => "ICCS community (kwh by energy meter)",
                            }, Community) do |community|
  community.clustering_id = 2
end

initialize_with_id_and_name({
                                3 => "smart plug (kwh by power sensor)",
                                4 => "hem (kwh by power sensor)",
                                5 => "smart plug (kwh by energy meter)",
                                6 => "hem (kwh by energy meter)",
                                7 => "DEMO smart plug (kwh by power meter)",
                                8 => "DEMO smart plug (kwh by energy meter)",
                            }, Community) do |community|
  community.clustering_id = 3
end

initialize_with_id_and_name({
                                9 => "Protergeia Community 1",
                                10 => "Protergeia Community 2",
                                11 => "Protergeia Community 3",
                            }, Community) do |community|
  community.clustering_id = 4
end

initialize_with_id_and_name({
                                12 => "flex",
                            }, Community) do |community|
  community.clustering_id = 5
end


puts "Created #{Community.all.count} Communities"

initialize_with_id_and_name({
                                1 => "Industrial",
                                2 => "Commercial",
                                3 => "Professional",
                                4 => "Public lighting",
                                5 => "Residential",
                            }, BuildingType)
puts "Created #{BuildingType.all.count} Building types"

# initialize_with_id_and_name({
#                                 1 => "Night hours",
#                                 2 => "Weekend",
#                                 3 => "Mon-Fri",
#                                 4 => "Peak hours",
#                             }, EccType)
# puts "Created #{EccType.all.count} ECC types"

# [[1,3],[2,1],[3,1],[4,4],[5,2],[6,2]].each do |id, ecc_type_id|
#   EccTerm.where(id: id).first_or_initialize.tap do |ecc_term|
#     ecc_term.ecc_type_id = ecc_type_id
#     ecc_term.save!
#   end
# end

# [[1,:weekly_per_day,1,5,1],
#  [2,:daily_per_hour,8,20,1],
#  [3,:weekly_per_day,1,5,2],
#  [4,:daily_per_hour,0,8,2],
#  [5,:weekly_per_day,1,5,3],
#  [6,:daily_per_hour,20,24,3],
#  [7,:yearly_per_month,6,9,4],
#  [8,:daily_per_hour,14,17,4],
#  [9,:weekly_per_day,0,0,5],
#  [10,:weekly_per_day,6,6,6]].each do |id,period,start,stop,ecc_term_id|
#   EccFactor.where(id: id).first_or_initialize.tap do |ecc_factor|
#     ecc_factor.period = period
#     ecc_factor.start = start
#     ecc_factor.stop = stop
#     ecc_factor.ecc_term_id = ecc_term_id
#     ecc_factor.save!
#   end
# end



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


["Consumer", "Community::HABTM_Consumers", "DataPoint"].each do |tbl_name|
#["Consumer", "Community::HABTM_Consumers"].each do |tbl_name|
  dbconn = ActiveRecord::Base.connection_pool.checkout
  raw  = dbconn.raw_connection
  begin
    file = File.new "db/initdata/#{tbl_name}.csv"        # open a compressed file
    dbconn.disable_referential_integrity do
      if tbl_name == "Community::HABTM_Consumers"
        tbl_name.constantize.where(community_id: [1 .. 11, 100 .. 105]).delete_all
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


[[1, 'smart plug 1', 'ZWaveNode005'],
 [2, 'smart plug 2', 'ZWaveNode006']].each do |id,name,mqtt_name|
  SmartPlug.where(id: id).first_or_initialize.tap do |smart_plug|
    smart_plug.consumer_id = 7
    smart_plug.name = name
    smart_plug.mqtt_name = mqtt_name
    smart_plug.save!
  end
end

ActiveRecord::Base.connection_pool.with_connection do |dbconn|
  ActiveRecord::Base.descendants do |t|
    dbconn.checkout.reset_pk_sequence!(t.table_name)
  end
end

