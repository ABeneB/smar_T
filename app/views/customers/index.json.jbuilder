json.array!(@customers) do |customer|
  json.extract! customer, :id, :company_id, :address, :telefon, :priority, :name
  json.url customer_url(customer, format: :json)
end
