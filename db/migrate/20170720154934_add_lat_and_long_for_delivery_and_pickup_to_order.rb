class AddLatAndLongForDeliveryAndPickupToOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :latitude, :float
    remove_column :orders, :longitude, :float
    add_column :orders, :pickup_lat, :float
    add_column :orders, :pickup_long, :float
    add_column :orders, :delivery_lat, :float
    add_column :orders, :delivery_long, :float
  end
end
