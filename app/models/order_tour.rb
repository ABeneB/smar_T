class OrderTour < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  belongs_to :tour
  belongs_to :company
  belongs_to :tour
  
  # Koordinaten aus Adresse
  geocoded_by :location   
  after_validation :geocode

end
