class Company < ActiveRecord::Base
    belongs_to :user
    has_one :restriction
    
    # Koordinaten aus Adresse
    geocoded_by :address   
    after_validation :geocode
    
end
