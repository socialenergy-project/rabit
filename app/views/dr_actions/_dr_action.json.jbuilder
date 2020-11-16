json.extract! dr_action, :id, :dr_target_id, :consumer_id, :volume_planned, :volume_actual, :price_per_mw, :created_at, :updated_at
json.url dr_action_url(dr_action, format: :json)
