json.array!(@vehicles) do |vehicle|
  json.extract! vehicle, :id, :user_id, :position, :capacity, :duration, :driver_id
  json.url vehicle_url(vehicle, format: :json)
end
