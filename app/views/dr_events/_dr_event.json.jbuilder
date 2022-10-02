json.extract! dr_event, :id, :name, :starttime, :consumer_category, :interval, :price, :state, :dr_type, :created_at, :updated_at
json.dr_targets dr_event.dr_targets do |dr_target|
  json.partial! "dr_targets/dr_target", dr_target: dr_target
end
json.url dr_event_url(dr_event, format: :json)
