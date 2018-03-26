class RemoveRedundantReferences < ActiveRecord::Migration
  def change
    remove_reference :customers, :user, index: true
    remove_reference :depots, :user, index: true
    remove_reference :drivers, :company, index: true
    remove_reference :order_tours, :user, index: true
    remove_reference :order_tours, :company, index: true
    remove_reference :orders, :company, index: true
    remove_reference :orders, :user, index: true
    remove_reference :restrictions, :user, index: true
    remove_reference :tours, :company, index: true
    remove_reference :tours, :user, index: true
    remove_reference :vehicles, :user, index: true
  end
end
