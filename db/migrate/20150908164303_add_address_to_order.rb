class AddAddressToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :adress, :string
  end
end