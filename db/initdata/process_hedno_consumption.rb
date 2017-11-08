#!/usr/bin/env ruby

require 'csv'

CSV.open("db/initdata/DataPoint.csv", "wb") do |csv|
  csv << ['consumer_id', 'interval_id', 'timestamp', 'consumption', 'created_at', 'updated_at']

  [ 'db/initdata/biomhxanikoi.csv', 'db/initdata/epaggelmatikoi.csv', 
    'db/initdata/biomhxanikoi_MV.csv', 'db/initdata/fwtismos_odwn_plateiwn.csv', 
    'db/initdata/oikiakoi.csv', 'db/initdata/emporikoi_MV.csv' ].each do |file|
    puts file
    CSV.foreach(file, col_sep: "\t") do |row|
      csv << [row[0], row[1], DateTime.parse(row[2]).new_offset(0), row[3]] + 2.times.map{|t| DateTime.now} 
    end
  end

end


