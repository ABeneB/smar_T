json.array!(@order_tours) do |order_tour|
  json.extract! order_tour, :id, :user_id, :order_id, :tour_id, :company_id, :location, :place
  json.url order_tour_url(order_tour, format: :json)
end
