class Tour < ActiveRecord::Base
  belongs_to :driver
  has_many :order_tours, -> { order(place: :asc) }, dependent: :delete_all
end
