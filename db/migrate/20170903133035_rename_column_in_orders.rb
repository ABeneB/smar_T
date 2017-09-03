class RenameColumnInOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :activ, :active
  end
end
