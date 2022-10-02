json.extract! dr_target, :id, :dr_event_id, :ts_offset, :volume, :dr_plan_actions, :dr_actions, :cleared_price, :created_at, :updated_at
json.url dr_target_url(dr_target, format: :json)
