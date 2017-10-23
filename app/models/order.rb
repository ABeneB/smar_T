class Order < ActiveRecord::Base
  belongs_to :customer

  after_validation :geocode_locations

  # update geo coordiantes for pickup and delivery location
  def geocode_locations
    coords = Geocoder.coordinates(self.location)
    unless coords.nil?
      self.lat = coords[0]
      self.long = coords[1]
    end
  end
end
