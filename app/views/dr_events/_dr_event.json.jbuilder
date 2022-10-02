json.extract! dr_event, :id, :name, :starttime, :consumer_category, :interval, :price, :state, :dr_type, :dr_targets, :created_at, :updated_at
json.url dr_event_url(dr_event, format: :json)
