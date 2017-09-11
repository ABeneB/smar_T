class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :tours
  has_one :vehicle

  delegate :company, to: :user

  def active_tour(algorithm = nil, status = nil)
    options = {}
    options[:driver_id] = self.id
    if algorithm then options[:algorithm] = algorithm end
    if status then options[:status] = status end
    Tour.where(options).last
  end
end
