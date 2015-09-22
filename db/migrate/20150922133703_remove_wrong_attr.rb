class RemoveWrongAttr< ActiveRecord::Migration
  def change
    remove_column :orders, :adress
    remove_column :orders, :address
  end
end