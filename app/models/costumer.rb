class Costumer < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_many :order

  validates :priority, inclusion: { in: ["A", "B", "C", "D", "E"],
  message: "%{value} ist nicht zulässig. Bitte benutzen Sie A,B,C, D oderr E" }
  
  # Koordinaten aus Adresse
  geocoded_by :address   
  after_validation :geocode
  
end
