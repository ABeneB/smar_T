class SessionsController < Devise::SessionsController
  after_filter :set_google_maps_api_key, :only => :create

  def set_google_maps_api_key
    Geocoder.configure(api_key: current_user.try(:company).try(:google_maps_api_key))
  end
end