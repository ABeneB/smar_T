class CreateOrderTours < ActiveRecord::Migration
  def change
    create_table :order_tours do |t|
      t.references :user, index: true
      t.references :order, index: true
      t.references :tour, index: true
      t.references :company, index: true
      t.string :location
      t.integer :place

      t.timestamps
    end
  end
end
