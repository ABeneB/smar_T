class Company < ActiveRecord::Base
    has_many :users
    has_many :customers
    has_one :restriction
    
    validates :name, presence: {message: "Dieses Feld muss ausgefüllt werden"}
   validates :address, presence: {message: "Dieses Feld muss ausgefüllt werden"}
   
    # Koordinaten aus Adresse
    geocoded_by :address
    after_validation :geocode

    # Gibt alle Driver zurück, die der Company indirekt über zugewiesene User angehören.
    def drivers
      Driver.where(user_id: self.users.ids)
    end

    # Gibt alle Orders zurück, die der Company indirekt über zugewiesene Customer angehören.
    def orders
      Order.where(customer_id: self.customers.ids)
    end

    # Gibt alle Tours zurück, die der Company indirekt über zugewiesene Customer angehören.
    def tours
      Tour.where(driver_id: self.drivers.ids)
    end

    # Returns true if time window restriction exists for this company
    def time_window_restriction?
      self.try(:restriction).try(:time_window) ? true : false
    end

    # Returns true if capacity restriction exists for this company
    def capacity_restriction?
      self.try(:restriction).try(:capacity_restriction) ? true : false
    end

    # Returns true if work time restriction exists for this company
    def work_time_restriction?
      self.try(:restriction).try(:work_time) ? true : false
    end
end
