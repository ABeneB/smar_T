class Company < ActiveRecord::Base
    has_many :users
    has_many :customers
    has_one :restriction

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
end
