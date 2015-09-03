class CreateCostumers < ActiveRecord::Migration
  def change
    create_table :costumers do |t|
      t.references :user, index: true
      t.references :company, index: true
      t.string :address
      t.string :telefon
      t.string :priority

      t.timestamps
    end
  end
end
