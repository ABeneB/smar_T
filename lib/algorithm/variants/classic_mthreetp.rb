module Algorithm
  module Variants

    class ClassicMThreeTP < Heuristic

      def initialize(company, algorithm)
        @algorithm = algorithm
        super(company)
      end

      def run(orders = [], vehicles = [])
        @orders = orders
        @drivers = vehicles

        # Prüfen ob Prioritätsstufen bestehen
        if @company.restriction.try(:priorities)
          # orders ändern zu array von arrays, für jede priority eine array
          orders_array = by_priority()
          # Die Order nach prio zuteilen
          orders_array.each do |prio_orders|
            # leere PrioGruppen ignorieren
            if prio_orders.present?
              order_count = prio_orders.length
              # Matrix für jede Prioritässtufe
              matrix = build_matrix(prio_orders)

              # jede Prioritätsstufe nacheinander bearbeiten
              solve_matrix(matrix, order_count)
            end
          end
        else # keine Prioritätsstufen
          # Matrix zwischen allen Drivern und allen Orders aufspannen
          matrix = build_matrix(orders)

          # Alle Orders in Matrix zuteilen
          solve_matrix(matrix, orders.length)
        end
        # Touren löschen, die nur aus 3 OrderTours bestehen (vp, depot, home), also keine Order bearbeiten
        ##touren = Tour.where(company_id: company.id)
        touren = @company.tours.where(algorithm: @algorithm)
        touren.each do |tour|
          # leere touren pdp löschen
          if tour.order_tours.length == 2 && @company.restriction.problem == "PDP"
            tour.order_tours.each do |order_tour|
                order_tour.destroy
            end
            tour.destroy
          # leere touren pd und pp löschen
          elsif tour.order_tours.length == 3
            tour.order_tours.each do |order_tour|
              #order_tour.destroy ToDo
            end
            #tour.destroy ToDo
          end
        end
      end

      # Matrix für Drivers und Orders
      def build_matrix(current_orders)
        matrix = []
        # MV oder SV wird automatisch durch die Anzahl von Drivern in Drivers beachtet
        # für jede Order...
        current_orders.each do |order|
          #... jeden Driver
          @drivers.each do |driver|
            possible_tour = [] # [Driver, Order, Tour]
            # die Zeit, samt Driver und Order, in possible_tour speichern
            possible_tour.push(driver)
            possible_tour.push(order)
            # die "echte" tour einfügen
            possible_tour.push(build_tour(order,driver))
            # anschließend in die matrix pushen
            matrix.push(possible_tour)
          end
        end

        matrix #return - matrix ist ein langes Array (beachten!)
      end

      # MMM durchführen
      def solve_matrix(matrix, order_count)
        # für jeder Order eine Tour finden
        tmp = 0
        if (matrix.present?)
          while tmp < order_count
            shortest_tour = matrix[0] # erste tour als shortest_tour
            # schnellste Tour ermitteln
            matrix.each do |possible_tour|
              # tour ist im dritten element [2] von possible_tour
              duration_shortest_tour = calc_tour_duration(shortest_tour[2])
              duration_tour = calc_tour_duration(possible_tour[2])
              # Wenn tourtime/|TR| kürzer ist...
              if (@algorithm == AlgorithmEnum::M3PDP)
                if (duration_shortest_tour/shortest_tour[2].length) > (duration_tour/shortest_tour[2].length)
                  shortest_tour = possible_tour # ...dann ist die possible_tour die neue shortest_tour
                end
              elsif (@algorithm == AlgorithmEnum::M3PDPDELTA)
                if((duration_shortest_tour - Driver.find(shortest_tour[0]).active_tour(@algorithm, StatusEnum::GENERATED).duration) > (duration_tour - Driver.find(possible_tour[0]).active_tour(@algorithm, StatusEnum::GENERATED).duration))
                  shortest_tour = possible_tour # ...dann ist die possible_tour die neue shortest_tour
                end
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

      # Nach einer Zuteilung die matrix erneuern
      def update_matrix(matrix, driver, order)
        # Alle Einträge in matrix mit order löschen
        length = matrix.length
        while length > 0
          element = matrix[length-1]
          if element[1].id == order.id # in element[1] steht die order
              matrix.delete_at(length-1)
          end
          length -= 1
        end
        # Alle Fahrzeiten von Driver updaten
        matrix.each_with_index do |tour, index|
          # Alle Einträge von Driver updaten
          if tour[0].id == driver.id # Driver steht in tour[0]
              # Tour neuberechnen
              tour[2] = build_tour(tour[1], tour[0])
          end
        end
        matrix
      end

      # Erstellt die OrderTour objekte und speichert die neue Tour und OrderTour in der DB
      def commit_order(driver, order, tour)
        # driver.tour kopieren, um neue OrderTour einzufügen
        driver_tour = Tour.where(driver: driver, status: StatusEnum::GENERATED, algorithm: @algorithm).take
        # Tour erstellen, falls keine existiert
        if driver_tour.nil?
          driver_tour = Tour.create(driver: driver, status: StatusEnum::GENERATED, algorithm: @algorithm)
        end
        #Neue Order_Tours identifizieren und in DB anlegen
        tour.each do |order_tour|
          # Wenn OrderTour noch nicht existiert...
          if order_tour.id.nil?
            # ...Element anlegen in DB speichern
            if order_tour.duration.nil?
                #order_tour.duration = 0
            end

            order_tour.tour_id = driver_tour.id
          end
          # Änderungen (wie place und time speichern)
          order_tour.save
          # .place anpassen
          unless order_tour.id.nil?
            if order_tour.place != OrderTour.where(id: order_tour.id) && OrderTour.find(order_tour.id)
                ot = OrderTour.find(order_tour.id)
                ot.place = order_tour.place
                ot.save
            end
          end
        end
          # Duration setzen
          # Tour speichern und Faher zuordnen
          # Order deaktivieren, damit sie in nächsten Planungen nicht versehentlich verplant wird
          # FIXME - Für Produkivbetrieb wieder einkommentieren
          # ToDo
          order.active = false
          order.save
      end

      # liefert die neue Tour (aufbauend auf der alten) von Drivers inklusive Order
      def build_tour(order, driver)
        # Entsprechend dem Tourenplanungsproblem den Insertionalgorithmus aufrufen
        unless @company.restriction.nil?
          if @company.restriction.problem == "PDP"
            tour = insertion_pdp(order, driver)
          elsif @company.restriction.problem == "DP"
            tour = insertion_dp(order, driver)
          elsif @company.restriction.problem == "PP"
            tour = insertion_pp(order, driver)
          end
          tour # return tour
        else
          tour = insertion_dp(order, driver) # default if not restriction is set
        end
      end # end build_tour()

      #nicht getestet
      # Insertionalgo für PDP
      def insertion_pdp(order, driver)
        # load tour vom driver (wenn eine besteht)
        old_tour = []

        # Alle OrderTour Elemente laden und old_tour befüllen
        unless driver.active_tour(@algorithm, StatusEnum::GENERATED).nil?
          # sortiert nach place
          order_tours = driver.active_tour(@algorithm, StatusEnum::GENERATED).order_tours
          order_tours = driver_tour.sort {|x,y| x.place <=> y.place}
          order_tours.each do |tour_element|
            old_tour.push(tour_element)
          end
        end

        #Wenn es keine alte Tour gab, neue Tour erzeugen
        if old_tour.empty?
          # Tour erzeugen
          driver_tour = Tour.create(driver: driver, status: StatusEnum::GENERATED, algorithm: @algorithm)
          # startpostion einfügen
          vehicle_position = create_vehicle_position(driver)
          vehicle_position.tour_id = driver_tour.id
          vehicle_position.place = 0
          vehicle_position.save
          # home einfügen - entspricht unternehmensadresse
          home = create_home()
          home.tour_id = driver_tour.id
          home.place = 1
          home.save
          # old_tour befüllen
          old_tour.push(vehicle_position)
          old_tour.push(home)
        end

        # Order in zwei OrderTours zerlegen
        # Pickup OrderTour
        order_tour_pickup = create_pickup(order)
        # Delivery OrderTour
        order_tour_delivery = create_delivery(order)
        # Array für beste tour
        best_tour = []
        new_tour = []

        # OrderTours an verschiedenen Positionen von old_tour einsetzen
        old_tour.each_with_index do |location_first, index_first|
          # Abbrechen bevor nach home eingesetzt wird
          if index_first+1 == old_tour.length
            break
          end

          #potenziell neue Tour erstellen
          new_tour = duplicate_tour_array(old_tour)

          # Pickup einsetzen
          new_tour.insert(index_first+1, order_tour_pickup)
          # OrderTour.time updaten
          update_time(new_tour, index_first+1)

          # Wenn eine Capacity_restriction besteht...
          unless @company.restriction.nil?
            if @company.restriction.capacity_restriction
              # ...Order.capacity_status updaten
              update_capacity(new_tour_index_first)
            end
          end

          # Delivery in new_tour einsetzen
          new_tour.each_with_index do |location_second, index_second|
            # Abbrechen bevor nach home eingesetzt wird
            if index_second+1 == new_tour.length
              break
            end
            # Delivery erst nach Pickup einsetzen
            if index_second > index_first+1
              #Delivery einsetzen
              new_tour.insert(index_second+1, order_tour_delivery)

              # OrderTour.time updaten
              update_time(new_tour, index_second+1)
              # Wenn eine Capacity_restriction besteht...
              if restriction.capacity_restriction
                # ...Order.capacity_status updaten
                update_capacity(new_tour, index_second+1)
              end
              # Prüfen ob Beschränkungen eingehalten werden
              if check_restriction(new_tour, driver)
                break
              end
            end

            # best_tour = erste new_tour
            if best_tour.length < new_tour.length
              best_tour = duplicate_tour_array(new_tour)
            else # wenn das schon passiert ist...
              # ...überprüfen ob die neue tour kürzer ist als die vorherige
              if calc_tour_duration(new_tour) < calc_tour_duration(best_tour)
                  best_tour = duplicate_tour_array(new_tour)
              end
            end
          end
        end
        # .place (reihenfolge) speichern
        best_tour.each_with_index do |order_tour, index|
          order_tour.place = index
        end
        best_tour # return
      end

      # Insertionalgo für DP
      def insertion_dp(order, driver)
        # load tour vom driver (wenn eine besteht)
        old_tour = []
        # Alle OrderTour Elemente laden und old_tour befüllen
        unless driver.active_tour(@algorithm, StatusEnum::GENERATED).nil?
            # sortiert nach place
            driver_tour = driver.active_tour(@algorithm, StatusEnum::GENERATED).order_tours
            driver_tour = driver_tour.sort {|x,y| x.place <=> y.place}
            driver_tour.each do |tour_element|
              old_tour.push(tour_element)
            end
        end

        #Wenn es keine alte Tour gab, neue Tour erzeugen
        if old_tour.empty?
            # Tour erzeugen
            driver_tour = Tour.create(driver: driver, status: StatusEnum::GENERATED, algorithm: @algorithm)
            # startpostion einfügen
            vehicle_position = create_vehicle_position(driver)
            vehicle_position.tour_id = driver_tour.id
            vehicle_position.place = 0
            vehicle_position.save
            #depot einfügen
            depot = create_depot()
            depot.tour_id = driver_tour.id
            #depot.capacity = driver.vehicle.capacity # Fahrzeug vollbeladen
            depot.place = 1
            depot.save
            # home einfügen - entspricht unternehmensadresse
            home = create_home()
            home.tour_id = driver_tour.id
            home.place = 2
            home.save
            # old_tour befüllen
            old_tour.push(vehicle_position)
            old_tour.push(depot)
            old_tour.push(home)
        end

        # Delivery OrderTour
        order_tour_delivery = create_delivery(order)

        # Array für beste tour
        best_tour = []

        # OrderTour an verschiedenen Positionen einsetzen
        old_tour.each_with_index do |location, index|
          # Abbrechen bevor nach home eingesetzt wird
          if index+2 == old_tour.length
            break
          end
          # index+2 damit erst nach vehicle_position und erstem depot eingesetzt wird

          # Potenziell neue Tour erstellen

          new_tour = duplicate_tour_array(old_tour)

          # Delivery einsetzen
          new_tour.insert(index + 2, order_tour_delivery)

          # OrderTour.time updaten
          update_time(new_tour, index+2)

          # Wenn eine Capacity_restriction besteht...
          unless @company.restriction.nil?
            if @company.restriction.capacity_restriction
              # ...Order.capacity_status updaten
              update_capacity(new_tour, index+2)
            end
          end

          # Prüfen ob Beschränkungen eingehalten werden
          if check_restriction(new_tour, driver)
            break
          end

          # best_tour mit ersten new_tour befüllen
          if best_tour.length < new_tour.length
            best_tour = duplicate_tour_array(new_tour)
          else # wenn das schon passiert ist...
            # ...überprüfen ob die neue tour kürzer ist als die vorherige
            if calc_tour_duration(new_tour) < calc_tour_duration(best_tour)
              best_tour = duplicate_tour_array(new_tour)
            end
          end
        end

        # Wenn keine zulässige Tour gebildet werden konnte
        if best_tour.empty?
          # Tour zurückmelden mit langer Fahrzeit, um anzuzeigen, dass keine zulässige gebildet werden konnte
          best_tour.push(OrderTour.new(time: 10000, kind: "home"))
        end
        # .place (Reihenfolge) speichern
        best_tour.each_with_index do |order_tour, index|
          order_tour.place = index
        end

        best_tour # return
      end

      #nicht getestet
      # Insertionalgo für PP
      def insertion_pp(order, driver)
        # load tour vom driver (wenn eine besteht)
        old_tour = []

        # Alle OrderTour Elemente laden und old_tour befüllen
        unless driver.active_tour(@algorithm, StatusEnum::GENERATED).nil?
          # sortiert nach place
          driver_tour = driver.active_tour(@algorithm, StatusEnum::GENERATED).order_tours
          driver_tour = driver_tour.sort {|x,y| x.place <=> y.place}
          driver_tour.each do |tour_element|
              old_tour.push(tour_element)
          end
        end

        #Wenn es keine alte Tour gab, neue Tour erzeugen
        if old_tour.empty?
          # Tour erzeugen
          driver_tour = Tour.create(driver: driver, status: StatusEnum::GENERATED, algorithm: @algorithm)
          # startpostion einfügen
          vehicle_position = create_vehicle_position(driver)
          vehicle_position.tour_id = driver_tour.id
          vehicle_position.place = 0
          vehicle_position.save
          # home einfügen - entspricht unternehmensadresse
          home = create_home()
          home.tour_id = driver_tour.id
          home.place = 1
          home.save
          driver.tour = driver_tour
          # old_tour befüllen
          old_tour.push(vehicle_position)
          old_tour.push(home)
        end

        # Pickup OrderTour
        order_tour_pickup = create_pickup(order)

        # OrderTour an verschiedenen Positionen einsetzen
        old_tour.each_with_index do |location, index|
          # Abbrechen bevor nach/zwischen letzten depot und home eingesetzt wird
          if index+1 == old_tour.length
            break
          end

          #potenziell neue Tour erstellen
          new_tour = duplicate_tour_array(old_tour)

          # Pickup einsetzen
          new_tour.insert(index+1, order_tour_pickup)

          # OrderTour.time updaten
          update_time(new_tour, index+1)
          # Wenn eine Capacity_restriction besteht...
          if restriction.capacity_restriction
            # ...Order.capacity_status updaten
            update_capacity(new_tour, index)
          end

          # Prüfen ob Beschränkungen eingehalten werden
          if check_restriction(new_tour, driver)
            break
          end

          # Depot als letztes vor home einsetzen, zum Entladen
          # Bestehendes Depot anpassen .capacity
          # Depot einsetzen
          depot.capacity = old.tour[tour.length-2].capacity_status*-1 # Fahrzeug wird entladen
          old_tour.insert(old_tour.length-2 , depot)
          # Zeit und Kapazität updaten
          update_time(old_tour, tour.length-2)
          update_capacity(old_tour, tour.length-2)
          # best_tour mit ersten new_tour befüllen
          if best_tour.length < new_tour.length
            best_tour = duplicate_tour_array(new_tour)
          else # wenn das schon passiert ist...
            # ...überprüfen ob die neue tour kürzer ist als die vorherige
            if calc_tour_duration(new_tour) < calc_tour_duration(best_tour)
                best_tour = duplicate_tour_array(new_tour)
            end
          end
        end
        # .place (reihenfolge) speichern
        best_tour.each_with_index do |order_tour, index|
          order_tour.place = index
        end
        tour
      end

      #Orders in Gruppen nach den Priorities einteilen
      def by_priority()
        # Array für Sorteriung der Orders nach prio
        prioA=[]
        prioB=[]
        prioC=[]
        prioD=[]
        prioE=[]
        @orders.each do |order|
          # Prüfen ob es priorities gibt
          unless order.customer.nil?
            # wenn ja, dann nach der priority sortieren
            if order.customer.priority == "A"
              prioA.push(order)
            elsif order.customer.priority == "B"
              prioB.push(order)
            elsif order.customer.priority == "C"
              prioC.push(order)
            elsif order.customer.priority == "D"
              prioD.push(order)
            else
              prioE.push(order)
            end
          else# Wenn es kein Prio gibt, dann in D
            prioD.push(order)
          end
        end
        prioArray =[prioA, prioB, prioC, prioD, prioE]
        prioArray
      end

      # erzeugt echte Copy von Array
      def duplicate_tour_array (tour)
          new_tour = []
          tour.each do |element|
              new_tour.push(element.clone)
          end
          new_tour
      end

    end
  end
end
