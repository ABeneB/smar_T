class CreateRestrictions < ActiveRecord::Migration
  def change
    create_table :restrictions do |t|
      t.references :company, index: true
      t.references :user, index: true
      t.string :problem
      t.boolean :dynamic
      t.boolean :multi_vehicle
      t.boolean :time_window
      t.boolean :capacity_restriction
      t.boolean :priorities
      t.boolean :work_time

      t.timestamps
    end
  end
end
