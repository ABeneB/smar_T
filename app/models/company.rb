class Company < ActiveRecord::Base
    belongs_to :user
    
    # Koordinaten aus Adresse
    geocoded_by :address   
    after_validation :geocode
  
end
