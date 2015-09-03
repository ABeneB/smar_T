class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.references :user, index: true
      t.references :company, index: true
      t.datetime :work_start_time
      t.datetime :work_end_time
      t.boolean :activ
      t.integer :working_time

      t.timestamps
    end
  end
end
