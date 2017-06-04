module Algorithm
  module Variants

    class SavingsPlusPlus < Heuristic

      def run(orders = [], drivers = [])

        day_orders = orders
        day_drivers = drivers
        while day_orders.any? do
          day_tours = init(day_orders, day_drivers)
    
          #optimize(day_tours)
          #saveTours(day_tours, day_orders, day_drivers)
        end
      end

      def init(day_orders, day_drivers)
        day_tours = []
        first_order = day_orders[0]
        driver = best_driver(first_order, day_drivers)
        day_orders.delete_at(0)
        if driver
          tour = build_trivial_tour(first_order, driver)
          day_tours.push(tour)
          day_orders.each_with_index do |order, index|
            trivial_tour = build_trivial_tour(order, driver)
            if check_restriction(trivial_tour, order, driver)
              day_tours.push(trivial_tour)
              day_orders.delete_at(index)
            end
          end
          return day_tours
        else
          init(day_orders, day_drivers) # recursive call
        end
      end

      def optimize

      end

      def saveTours

      end

      private

        def best_driver(order, drivers)
          #for identifying the best driver among possible drivers
          compatible_trivial_tours = []
          drivers.each do |driver|
            trivial_tour = build_trivial_tour(order, driver)
            if check_restriction(trivial_tour, order, driver)
              compatible_trivial_tours.push(trivial_tour)
            end
          end

          unless compatible_trivial_tours.empty?
            #return tours with lowest tour duration
            best_trivial_tour = compatible_trivial_tours.min_by { |tour| tour.duration } # return tours with lowest tour duration
            return best_trivial_tour.driver
          end
          return nil
        end

        def build_trivial_tour(order, driver)
          trivial_tour = Tour.create(driver_id: driver.id, duration: 0)
          # startpostion einfügen
          vehicle_position = create_vehicle_position(driver)
          vehicle_position.tour = trivial_tour
          vehicle_position.place = 0
          vehicle_position.save

          #depot einfügen
          depot = create_depot(vehicle_position)
          depot.tour = trivial_tour
          depot.capacity = driver.vehicle.capacity # Fahrzeug vollbeladen
          depot.place = 1
          depot.save

          # home einfügen - entspricht unternehmensadresse
          home1 = create_home(depot, driver)
          home1.tour = trivial_tour
          home1.place = 2
          home1.save

          delivery = create_delivery(order)
          delivery.tour = trivial_tour
          delivery.time = time_for_distance(home1, delivery)
          delivery.duration = order.duration_delivery
          delivery.place = 3
          delivery.save

          home2 = create_home(depot, driver)
          home2.tour = trivial_tour
          home2.time = time_for_distance(delivery, home2)
          home2.place = 4
          home2.save

          # trivial_tour befüllen
          tour_container = []
          tour_container.push(vehicle_position)
          tour_container.push(depot)
          tour_container.push(home1)
          tour_container.push(delivery)
          tour_container.push(home2)

          return trivial_tour
        end
    end
  end
end
