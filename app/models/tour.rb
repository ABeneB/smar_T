class Tour < ActiveRecord::Base
  belongs_to :driver
  has_many :order_tours, dependent: :delete_all
end
