require "algorithm/variants/models/combinedtourpair"

module Algorithm
  module Variants

    class SavingsPlusPlus < Heuristic

      def run(day_orders = [], day_drivers = [])
        while day_orders.any? && day_drivers.any? do
          day_tours = init(day_orders, day_drivers)
          optimize(day_tours)
          #saveTours(day_tours, day_orders, day_drivers)
        end
      end

      def init(day_orders, day_drivers)
        day_tours = []
        if day_orders.any?
          first_order = day_orders[0]
          driver = best_driver(first_order, day_drivers) # restriction check in best_driver
          day_orders.delete_at(0)
          if driver
            tour = build_trivial_tour(first_order, driver)
            day_tours.push(tour)

            # reverse for-loop because we are deleting elements
            for i in (day_orders.count - 1).downto(0)
              order = day_orders[i]
              #build trivial tour for every order
              trivial_tour = build_trivial_tour(order, driver)
              if check_restriction(trivial_tour.order_tours, driver)
                day_tours.push(trivial_tour)
                day_orders.delete(order)
              end
            end
            return day_tours
          else
            init(day_orders, day_drivers) # recursive call
          end
        end
        return day_tours
      end

      def optimize(day_tours)
        compatible_tour_pairs = create_compatible_tour_pairs(day_tours)
        calc_combined_tour_pair_savings(compatible_tour_pairs)
        compatible_tour_pairs.sort_by! { |combined_tour| combined_tour.saving }.reverse! # sort saving descending to start with the biggest saving

        # tested until this line
        while compatible_tour_pairs[0].saving >= 0 do
          best_saving_tour_pair = compatible_tour_pairs[0] # first tour has highest saving
          update_day_tours(day_tours, best_saving_tour_pair)
          # remove all combinedtourpair objects which contain tour2 (tj) of combined tour with highest saving
          compatible_tour_pairs.map! { |combined_tour|
            if combined_tour.tour1 == best_saving_tour_pair.tour1 || combined_tour.tour2 == best_saving_tour_pair.tour2
             # nil
             end
          }.compact!
          # recalculate savings for new ti
          recalculate_savings(compatible_tour_pairs, best_saving_tour_pair)
        end
      end

      def saveTours
        # TODO
      end

      private

        def best_driver(order, drivers)
          #for identifying the best driver among possible drivers
          compatible_trivial_tours = []
          drivers.each do |driver|
            trivial_tour = build_trivial_tour(order, driver)
            if check_restriction(trivial_tour.order_tours, driver)
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

          return trivial_tour
        end

        # returns compatible combinations of day tours as array of CombinedTourPairs objects
        def create_compatible_tour_pairs(day_tours)
          # build cartesian product of all day_tours without product of same tour and nil objects
          tour_pairs = day_tours.product(day_tours).map { |x, y| [x, y] if x != y }.compact!

          driver = day_tours[0].driver # driver of the first tour is the driver for all tours
          compatible_combined_tours = []
          tour_pairs.each do |tour1, tour2|
            # combine order_tours from two tours and remove redundant home and depot
            tour1_orders = tour1.order_tours
            tour2_orders = tour2.order_tours

            # combine tours
            # tour1_orders.values_at(0..(tour1_orders.length - 2)) // ignore depot (last element)
            # tour2_orders.values_at(2..(tour2_orders.length - 1)) // ignore home, depot (first elements)
            combined_tour = tour1_orders.values_at(0..(tour1_orders.length - 2)).concat(tour2_orders.values_at(3..(tour2_orders.length - 1)))
            combined_tour.each_with_index do |order_tour, index|
              order_tour.place = index
            end
            update_order_tour_times(combined_tour) # update of times for recently combined tour

            if check_restriction(combined_tour, driver)
              combined_tour_pair = CombinedTourPair.new(tour1, tour2, combined_tour)
              compatible_combined_tours.push(combined_tour_pair)
            end
          end
          compatible_combined_tours
        end

        def calc_combined_tour_pair_savings(combined_tours)
          combined_tours.each do |combined_tour_pair|
            combined_tour_duration = calc_tour_duration(combined_tour_pair.combined_order_tours)
            tour1_duration = calc_tour_duration(combined_tour_pair.tour1)
            tour2_duration = calc_tour_duration(combined_tour_pair.tour2)
            combined_tour_pair.saving = (tour1_duration + tour2_duration) - combined_tour_duration
          end
          combined_tours
        end

        def update_order_tour_times(order_tours)
          order_tours.each_with_index do |order, index|
            if index > 0 # skip first element because it has no previous element
              update_time(order_tours, index)
            end
          end
        end

        def update_day_tours(day_tours, combined_tour_pair)
          # remove tour 2 from day tours
          day_tours.delete(combined_tour_pair.tour2)
          combined_tour = create_tour_by_order_tours(combined_tour_pair)

          # replace tour 1 with combined tour
          day_tours.map! { |tour| tour = combined_tour if tour.equal?(tour1) }
        end

        def create_tour_by_order_tours(order_tours)
          # TODO Implementation missing
        end

        # probably check of restrictions required
        def recalculate_savings(compatible_tour_pairs, tour_pair)
          compatible_tour_pairs.each do ||
            # TODO
          end
        end
    end
  end
end
