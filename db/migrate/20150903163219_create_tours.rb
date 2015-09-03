class CreateTours < ActiveRecord::Migration
  def change
    create_table :tours do |t|
      t.references :user, index: true
      t.references :driver, index: true
      t.references :company, index: true
      t.integer :duration

      t.timestamps
    end
  end
end
