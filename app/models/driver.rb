class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :tours
  has_one :vehicle

  delegate :company, to: :user

  def active_tour(algorithm, status)
    Tour.where(driver_id: self.id, algorithm: algorithm, status: status).last
  end
end
