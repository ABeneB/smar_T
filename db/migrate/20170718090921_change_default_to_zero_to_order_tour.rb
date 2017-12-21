class ChangeDefaultToZeroToOrderTour < ActiveRecord::Migration
  def up
    change_column_default(:order_tours, :time, 0)
    change_column_default(:order_tours, :capacity_status, 0)
  end

  def down
    change_column_default(:order_tours, :time, nil)
    change_column_default(:order_tours, :capacity_status, nil)
  end
end
