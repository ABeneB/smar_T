class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.references :costumer, index: true
      t.references :company, index: true
      t.string :pickup_location
      t.string :delivery_location
      t.integer :capacity
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
