class AddTypeToOrderTours < ActiveRecord::Migration
  def change
    add_column :order_tours, :type, :string
  end
end
