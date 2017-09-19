# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Interval.where(duration: 900).first_or_initialize.tap do |interval|
  interval.name = "15 minutes"
  interval.save
end

Interval.where(duration: 3600).first_or_initialize.tap do |interval|
  interval.name = "1 hour"
  interval.save
end

Interval.where(duration: 86400).first_or_initialize.tap do |interval|
  interval.name = "Daily"
  interval.save
end

