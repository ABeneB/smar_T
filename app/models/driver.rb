class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :tours
  has_one :vehicle

  delegate :company, to: :user

  def active_tour
    Tour.where(driver_id: self.id).last
  end
end
