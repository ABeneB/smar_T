class AddCommentToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :comment, :string
  end
end
