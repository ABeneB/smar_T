json.array!(@orders) do |order|
  json.extract! order, :id, :user_id, :customer_id, :company_id, :pickup_location, :delivery_location, :capacity, :start_time, :end_time
  json.url order_url(order, format: :json)
end
