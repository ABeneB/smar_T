class Order < ActiveRecord::Base
  belongs_to :customer
 
 before_validation :timeToInt
  
 attr_accessor :hour, :minute

  validates :location, :customer, presence: true  
  validate :end_date_after_start_date?
  validate :start_time_in_past?, on: :create

  after_validation :geocode_locations

  def start_time_in_past?
    if self.start_time
      if self.start_time < Time.now
        errors.add(:start_time, I18n.t('start_time_in_past'))
      end
    end
  end

  def end_date_after_start_date?
    if self.start_time && self.end_time
      if self.end_time < self.start_time
        errors.add(:end_time, I18n.t('end_time_after_start_time'))
      end
    end
  end

  # update geo coordiantes for pickup and delivery location
  def geocode_locations
    coords = Geocoder.coordinates(self.location)
    unless coords.nil?
      self.lat = coords[0]
      self.long = coords[1]
    end
  end

  # returns assigned tour if exists
  def get_assigned_tour
    order_tour = OrderTour.find_by_order_id(self.id)
    unless order_tour.blank?
      order_tour.tour
    end
  end

def timeToInt
    if self.hour || self.minute
    	if hour.nil?
     		self.hour = 0
    	end
    	if minute.nil?
      	self.minute = 0
    	end
    	self.duration = 60 * Integer(hour) + Integer(minute)
    end
  end
  
  def intToTime
    self.hour = Integer(duration) / 60
    self.minute = Integer(duration) % 60
  end

end
