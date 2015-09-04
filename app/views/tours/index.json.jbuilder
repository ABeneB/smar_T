json.array!(@tours) do |tour|
  json.extract! tour, :id, :user_id, :driver_id, :company_id, :duration
  json.url tour_url(tour, format: :json)
end
