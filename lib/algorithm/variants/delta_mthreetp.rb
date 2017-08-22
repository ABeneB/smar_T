module Algorithm
  module Variants

    class DeltaMThreeTP < ClassicMThreeTP



      def run(orders = [], vehicles = [])
        raise NotImplementedError, "Subclasses must define `run`."
      end

      def solve_matrix(matrix, order_count)
        # für jeder Order eine Tour finden
        tmp = 0
        if (matrix.present?)
          while tmp < order_count
            shortest_tour = matrix[0] # erste tour als shortest_tour
            # schnellste Tour ermitteln
            matrix.each do |possible_tour|
              # tour ist im dritten element [2] von possible_tour
              duration_shortest_tour = calc_tour_time(shortest_tour[2])
              duration_tour = calc_tour_time(possible_tour[2])
              # Wenn tourtime/|TR| kürzer ist...
              if((duration_shortest_tour - Driver.find(shortest_tour[0]).active_tour.duration) > (duration_tour - Driver.find(possible_tour[0]).active_tour.duration))
                shortest_tour = possible_tour # ...dann ist die possible_tour die neue shortest_tour
              end
            end
            # Driver die Tour (samt neuer Order) zuteilen
            #shortest_tour[0] = driver ; [1] = order ; [2] tour
            commit_order(shortest_tour[0], shortest_tour[1], shortest_tour[2])

            # Workaround für .time problem
            shortest_tour[2].each_with_index do |order_tour, index|
              if index > 0
                if order_tour.time != time_for_distance(shortest_tour[2][index-1], order_tour)
                  order_tour.time = time_for_distance(shortest_tour[2][index-1], order_tour)
                  order_tour.save
                  order_tour.tour.duration = calc_tour_time(shortest_tour[2])
                  order_tour.tour.save
                end
              end
            end
            #update matrix - Löschen aller Einträge mit der Order und die Zeiten vom Fahrer updaten
            matrix = update_matrix(matrix, shortest_tour[0], shortest_tour[1])
            tmp += 1
          end
        end
      end

    end
  end
end
