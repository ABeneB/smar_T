class RenameColumnInDrivers < ActiveRecord::Migration
  def change
    rename_column :drivers, :activ, :active
  end
end
