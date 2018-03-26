class AddStatusAndAlgorithmToTours < ActiveRecord::Migration
  def change
    add_column :tours, :status, :integer
    add_column :tours, :algorithm, :integer
  end
end
