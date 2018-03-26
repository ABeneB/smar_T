class RemoveCapacityAndDurationAndLocationAndLatitudeAndLongitudeFromOrderTour < ActiveRecord::Migration
  def change
    remove_column :order_tours, :capacity, :integer
    remove_column :order_tours, :duration, :integer
    remove_column :order_tours, :location, :string
    remove_column :order_tours, :latitude, :float
    remove_column :order_tours, :longitude, :float
  end
end
