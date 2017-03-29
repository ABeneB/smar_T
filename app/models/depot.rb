class Depot < ActiveRecord::Base
  belongs_to :company

  # Koordinaten aus Adresse
  geocoded_by :address
  after_validation :geocode

end
