class AddGoogleMapsApiKeyToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :google_maps_api_key, :string
  end
end
