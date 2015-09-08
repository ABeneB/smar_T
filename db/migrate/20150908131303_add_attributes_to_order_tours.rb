class AddAttributesToOrderTours < ActiveRecord::Migration
  def change
    add_column :order_tours, :capacity, :integer
    add_column :order_tours, :capacity_status, :integer
    add_column :order_tours, :time, :integer
  end
end
