class OrderTour < ActiveRecord::Base
  belongs_to :order
  belongs_to :tour

  # Koordinaten aus Adresse
  geocoded_by :location
  after_validation :geocode

end
