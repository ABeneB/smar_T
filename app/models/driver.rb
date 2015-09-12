class Driver < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  
  validates :company, presence: true
  
end
