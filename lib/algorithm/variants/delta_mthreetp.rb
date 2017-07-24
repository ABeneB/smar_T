module Algorithm
  module Variants

    class DeltaMThreeTP < ClassicMThreeTP

      def run(orders = [], vehicles = [])
        raise NotImplementedError, "Subclasses must define `run`."
      end
    end
  end
end
