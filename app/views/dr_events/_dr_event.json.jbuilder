json.extract! dr_event, :id, :name, :starttime, :interval_id, :price, :state, :type, :created_at, :updated_at
json.url dr_event_url(dr_event, format: :json)
