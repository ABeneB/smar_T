class Driver < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_one :tour
  has_one :vehicle
  
  validates :company, presence: true
  
end
