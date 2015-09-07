json.array!(@companies) do |company|
  json.extract! company, :id, :user_id, :name, :address, :telefon
  json.url company_url(company, format: :json)
end
