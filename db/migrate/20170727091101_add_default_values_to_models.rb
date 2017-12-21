class AddDefaultValuesToModels < ActiveRecord::Migration
  def change
    change_column_default(:depots, :duration, 0)

    change_column_default(:orders, :capacity, 0)
    change_column_default(:orders, :duration_delivery, 0)
    change_column_default(:orders, :duration_pickup, 0)
  end
end
