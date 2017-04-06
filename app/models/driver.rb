class Driver < ActiveRecord::Base
  belongs_to :user
  has_one :tour
  has_one :vehicle

  delegate :company, to: :user
end
