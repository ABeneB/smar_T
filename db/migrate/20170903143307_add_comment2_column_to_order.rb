class AddComment2ColumnToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :comment2, :string
  end
end
