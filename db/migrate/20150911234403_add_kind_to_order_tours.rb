class AddKindToOrderTours < ActiveRecord::Migration
  def change
    add_column :order_tours, :kind, :string
    remove_column :order_tours, :type
  end
end