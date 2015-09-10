json.array!(@costumers) do |costumer|
  json.extract! costumer, :id, :user_id, :company_id, :address, :telefon, :priority, :name
  json.url costumer_url(costumer, format: :json)
end
