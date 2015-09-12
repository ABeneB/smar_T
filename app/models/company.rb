class Company < ActiveRecord::Base
    belongs_to :user
    has_one :restriction
    has_many :drivers
    has_many :orders
    
    # Koordinaten aus Adresse
    geocoded_by :address   
    after_validation :geocode
    
end
