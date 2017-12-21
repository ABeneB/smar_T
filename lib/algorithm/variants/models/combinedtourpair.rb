module Algorithm
  module Variants
    module Models
      class CombinedTourPair

        attr_accessor :tour1, :tour2, :order_tours, :saving

        def initialize(tour1, tour2, combined_order_tours)
          @tour1 = tour1
          @tour2 = tour2
          @order_tours = combined_order_tours
        end
      end
    end
  end
end
