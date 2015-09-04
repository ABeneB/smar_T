json.array!(@depots) do |depot|
  json.extract! depot, :id, :user_id, :company_id, :address, :duration
  json.url depot_url(depot, format: :json)
end
