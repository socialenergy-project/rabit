namespace :emulation do
  desc 'TODO'
  task for_dr: :environment do
    cat_lv = ConsumerCategory.find_or_create_by!(name: 'DR low voltage')

    100.times do |i|
      consumer = Consumer.find_or_create_by!(name: "DR low voltage #{i}", consumer_category: cat_lv)
      consumer.ecc_type&.destroy
      factor = EccFactor.new period: :daily_per_hour, start: 0, stop: 23
      term = EccTerm.new value: rand(0.015..0.025).round(3), price_per_mw: rand(50..150).round
      term.ecc_factors << factor
      ect = EccType.new(consumer: consumer, name: "SLA for low voltage #{i}")
      ect.ecc_terms << term
      ect.save!
    end

    cat_mv = ConsumerCategory.find_or_create_by!(name: 'DR medium voltage')

    20.times do |i|
      consumer = Consumer.find_or_create_by!(name: "DR low medium #{i}", consumer_category: cat_mv)
      consumer.ecc_type&.destroy
      factor = EccFactor.new period: :daily_per_hour, start: 0, stop: 23
      term = EccTerm.new value: rand(0.15..0.50).round(3), price_per_mw: rand(50..250).round
      term.ecc_factors << factor
      ect = EccType.new(consumer: consumer, name: "SLA for medium voltage #{i}")
      ect.ecc_terms << term
      ect.save!
    end
  end
end
