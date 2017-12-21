class AddCustomerReferenceToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :customer_reference, :integer
  end
end
