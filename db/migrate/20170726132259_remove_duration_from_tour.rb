class RemoveDurationFromTour < ActiveRecord::Migration
  def change
    remove_column :tours, :duration, :int
  end
end
