class Driver < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_one :tour
  
  validates :company, presence: true
  
end
