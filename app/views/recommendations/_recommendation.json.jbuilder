json.extract! recommendation, :id, :status, :recommendation_type_id, :scenario_id, :parameter, :created_at, :updated_at
json.url recommendation_url(recommendation, format: :json)
