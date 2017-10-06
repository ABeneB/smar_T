class Vehicle < ActiveRecord::Base
  belongs_to :company
  belongs_to :driver

  # Koordinaten aus Adresse
  geocoded_by :position
  after_validation :geocode

end
