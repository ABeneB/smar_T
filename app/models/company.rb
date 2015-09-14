class Company < ActiveRecord::Base
    has_many :user
    has_one :restriction
    has_many :drivers
    has_many :orders
    
    # Koordinaten aus Adresse
    geocoded_by :address   
    after_validation :geocode
    
end
