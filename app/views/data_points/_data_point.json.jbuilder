json.extract! data_point, :id, :consumer_id, :interval_id, :timestamp, :consumption, :flexibility, :created_at, :updated_at
json.url data_point_url(data_point, format: :json)
