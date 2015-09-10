class AddLatitudeAndLongitude < ActiveRecord::Migration
  def change
    add_column :companies, :latitude, :float
    add_column :companies, :longitude, :float
    add_column :costumers, :latitude, :float
    add_column :costumers, :longitude, :float
    add_column :depots, :latitude, :float
    add_column :depots, :longitude, :float
    add_column :orders, :latitude, :float
    add_column :orders, :longitude, :float
    add_column :vehicles, :latitude, :float
    add_column :vehicles, :longitude, :float
    add_column :order_tours, :latitude, :float
    add_column :order_tours, :longitude, :float
  end
end