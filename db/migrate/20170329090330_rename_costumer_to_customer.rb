class RenameCostumerToCustomer < ActiveRecord::Migration
  def change
    rename_table :costumers, :customers
  end
end
