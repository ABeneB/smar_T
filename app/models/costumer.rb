class Costumer < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_many :order

  validates :priority, inclusion: { in: ["A", "B", "C", "D"],
    message: "%{value} is not a valid priority, please use A,B,C or D" }
  
end
