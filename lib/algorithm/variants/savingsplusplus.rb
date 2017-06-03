module Algorithm
  module Variants

    class SavingsPlusPlus < Heuristic

      def run(orders = [], drivers = [])

        day_orders = orders
        day_drivers = drivers
        while day_orders.any? do
          #day_tours = initialize(day_orders, day_drivers)

          #optimize(day_tours)
          #saveTours(day_tours, day_orders, day_drivers)
        end
      end


      def initialize

      end

      def optimize

      end

      def saveTours

      end
    end
  end
end
