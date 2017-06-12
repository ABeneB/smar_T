module Algorithm
  module Variants

    class CombinedTourPair

      attr_accessor :tour1, :tour2, :combined_tour, :saving

      def initialize(tour1, tour2, combined_tour)
        @tour1 = tour1
        @tour2 = tour2
        @combined_tour = combined_tour
      end
    end
  end
end
