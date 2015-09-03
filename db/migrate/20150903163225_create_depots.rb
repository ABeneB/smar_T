class CreateDepots < ActiveRecord::Migration
  def change
    create_table :depots do |t|
      t.references :user, index: true
      t.references :company, index: true
      t.string :address
      t.integer :duration

      t.timestamps
    end
  end
end
