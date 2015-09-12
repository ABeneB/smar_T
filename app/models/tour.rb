class Tour < ActiveRecord::Base
  belongs_to :user
  belongs_to :driver
  belongs_to :company
  has_many :order_tours
end
