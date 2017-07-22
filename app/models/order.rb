class Order < ActiveRecord::Base
  belongs_to :customer

  after_validation :geocode_locations

  # update geo coordiantes for pickup and delivery location
  def geocode_locations
    if pickup_location
      coords = Geocoder.coordinates(self.pickup_location)
      self.pickup_lat = coords[0]
      self.pickup_long = coords[1]
    end
    if delivery_location
      coords = Geocoder.coordinates(self.delivery_location)
      self.delivery_lat = coords[0]
      self.delivery_long = coords[1]
    end
  end
end
