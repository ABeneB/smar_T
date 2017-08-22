class Customer < ActiveRecord::Base
  belongs_to :company
  has_many :orders
  validates :company, presence: {message: "Dieses Feld muss ausgefüllt werden"}
  validates :name, presence: {message: "Dieses Feld muss ausgefüllt werden"}
  validates :priority, inclusion: { in: ["A", "B", "C", "D", "E"],
  message: "Bitte benutzen Sie A,B,C, D oder E" }

  # Koordinaten aus Adresse
  geocoded_by :address
  after_validation :geocode

end
