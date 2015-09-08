json.array!(@users) do |user|
  json.extract! user, :id, :email, :last_sign_in_at, :created_at, :username, :role
  json.url company_url(user, format: :json)
end
