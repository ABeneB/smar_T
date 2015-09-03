class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.references :user, index: true
      t.string :position
      t.integer :capacity
      t.integer :duration
      t.references :driver, index: true

      t.timestamps
    end
  end
end
