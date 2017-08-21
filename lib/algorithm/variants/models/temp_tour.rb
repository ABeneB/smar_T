class TempTour
  include ActiveModel::AttributeMethods, ActiveModel::Model

  attr_accessor :driver, :order_tours

  def save
    tour = Tour.create(driver: driver)
    self.order_tours.each do |order_tour|
      order_tour.save(tour)
    end
  end

  def duration
    tour_duration = 0
    self.order_tours.each do |order_tour|
      tour_duration += order_tour.time
      tour_duration += order_tour.duration
    end
    tour_duration
  end
end