class OrderTour < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  belongs_to :tour
  belongs_to :company
end
