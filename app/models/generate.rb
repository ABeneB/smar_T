#Klasse zur Erstellung der Touren entsprechen der Konfiguration

#Ideas : durch OrderTour.time kann man herausfinden wie lange man von der vorherigen location zu dieser braucht. Dadruch weniger anfragen an Maps,
# denn man muss für jede Einsetzung nur die time vom eignen und nächsten location updaten und die nummerirung aller nachfolgenden orderTour +1

class Generate
    
    #Variablen
    attr_accessor :drivers, :orders, :company, :user
    # Depot und home können aus dem Kontext abgeleitet werden
    
    #Methoden
    #DONE
    # generiete die Touren für alle driver und orders entsprechend der company.restriction
    def generate_tours()
        # Prüfen ob Prioritätsstufen bestehen
        if company.restriction.priorities
            # orders ändern zu array von arrays, für jede priority eine array
            orders = by_priority()
            i = 0
            # Jedes order in orders nacheiander lösen
            while i < orders.length do
                # Matrix für jede Prioritässtufe
                matrix = build_matrix(orders[i])
                # jede Prioritätsstufe nacheinander bearbeiten
                solve_matrix(orders[i])
                i += 1 
            end
        # keine Prioritätsstufen
        else
            # Matrix zwischen allen Drivern und allen Orders aufspannen
            matrix = build_matrix()
            order_count = orders.length
            # Alle Orders in Matrix zuteilen 
            solve_matrix(matrix, order_count)
        end
    end # end generate_tour()
    
    #DONE
    # Matrix für Drivers und Orders
    def build_matrix()
        matrix = []
        possible_tour = [] # [Driver, Order, Tour]
        # MV oder SV wird autoamtisch durch die Anzahl von Drivern in Drivers beachtet
        # für jede Order...
        orders.each do |order|
            #... jeden Driver
            drivers.each do |driver|
                # die Zeit, samt Driver und Order, in possible_tour speichern
                possible_tour.push(driver)
                possible_tour.push(order)
                # die "echte" tour einfügen
                possible_tour.push(build_tour(order,driver))
                # anschließend in die matrix pushen
                matrix.push(possible_toure)
            end
        end
        matrix #return - matrix ist ein langes Array (beachten!)
    end
    
    #DONE
    # MMM durchführen
    def solve_matrix(matrix, order_count)
        # für jeder Order eine Tour finden
        while order_count < i
            shortest_tour = matrix[0] # erste tour als shortest_tour
            # schnellste Tour ermitteln
            matrix.each do |possible_tour|
                # tour ist im dritten element [2] von possible_tour
                duration_shortest_tour= calc_tour_time(shortest_tour[2])
                duration_tour= calc_tour_time(tour[2])
                # Wenn tour kürzer ist...
                if duration_shortest_tour > duration_tour 
                    shortest_tour = tour # ...dann ist die possible_tour die neue shortest_tour
                end
            end
            # leserlich umspeichern
            driver = shortest_tour[0]
            order = shortest_tour[1]
            tour = shortest_tour[2]
            # Driver die Tour (samt neuer Order) zuteilen
            commit_order(driver, tour, order)
            #update matrix - Löschen aller Einträge mit der Order und die Zeiten vom Fahrer updaten
            update_matrix(matrix, driver, order)
            i += 1
        end
    end
    
    #DONE
    # Nach einer Zuteilung die matrix erneuern
    def update_matrix(matrix, order, driver)
        # Alle Einträge in matrix mit order löschen
        matrix.for_each_with_index do |tour, index|
            # Order steht in tour[1]
            if tour[1].id == order.id
                # alten Eintrag entfernen
                matrix.delete_at(index)
            end
            # Driver steht in tour[0]
            if tour[0].id == driver.id
                # Tour neuberechnen
                tour = build_tour(tour[1], driver)
            end
        end
        matrix # return
    end # end update_matrix()
    
    #DONE
    # Erstellt die OrderTour objekte und speichert die neue Tour und OrderTour in der DB
    def commit_order(driver, tour, order)
        # alte Tour löschen
        driver.tour.destroy
        # neue Tour erstellen
        new_tour= tour.create(user_id: user.id, driver_id: driver_id, company_id: company.id, duration: 0) # FIXME tour.id automatisch?
        # fehlende Attribute setzen und mit new_tour verbinden
        tour.for_each_with_index do |order_tour, index|
            order_tour.user_id = user.id
            order_tour.tour_id = new_tour.id
            order_tour.company_id = user.company.id
            order_tour.place = index 
            order_tour.save # speichern in DB
        end
        # Duration setzen, entspricht letzen Tour element
        last_element = tour.last
        new_tour.duration=last_element.time
        # Driver mit Tour verbinden
        driver.tour_id= new_tour.id 
        # Order deaktivieren
        order.aktiv = false
    end # end commit_order()
    
    #DONE
    # liefert die neue Tour (aufbauend auf der alten) von Drivers inklusive Order
    def build_tour(order, driver)
        # Entsprechend dem Tourenplanungsproblem den Insertionalgorithmus aufrufen
        if company.restriction.problem == "PDP"
           tour = insertion_pdp(order, driver)
        elsif company.restriction.problem == "DP"
            tour = insertion_dp(order, driver)
        elsif company.restriction.problem == "PP"
            tour = insertion_pp(order, driver)
        end
        tour # return tour
    end # end build_tour()
    
    # FIXME
    # Insertionalgo für PDP
    def insertion_pdp(order, driver)
        # load tour vom driver (wenn eine besteht)
        old_tour = []
        # Alle OrderTour Elemente laden und old_tour befüllen
        OrderTour.where(tour_id: driver.tour_id).find_each do |tour_element|
            old_tour.push(tour_elemnt)
        end
        
        #Wenn es keine alte Tour gab, neue Tour vorbereiten
        if old_tour.empty?
            # startpostion einfügen
            vehicle_position = create_vehicle_position(driver)
            old_tour.push(vehicle_position)
            # home einfügen - entspricht unternehmensadresse
            home = create_home(vehicle_position, driver)
            old_tour.push(home)
        end
        
        # Order in zwei OrderTours zerlegen
        # Pickup OrderTour 
        order_tour_pickup = create_pickup(order)
        # Delivery OrderTour
        order_tour_delivery = create_delivery(order)
        # Array für beste tour
        best_tour = []
        
        # OrderTours an verschiedenen Positionen von old_tour einsetzen
        old_tour.for_each_with_index do |location_first, index_first|
            # Abbrechen bevor nach home eingesetzt wird
            if index_first+1 == new_tour.length
                break
            end
            #potenziell neue Tour erstellen
            new_tour = duplicate_tour_array(old_tour)
            
            # Pickup einsetzen
            new_tour.insert(index_first+1, order_tour_pickup)
            # OrderTour.time updaten
            new_tour = update_time(new_tour, index_first)
            # Wenn eine Capacity_restriction besteht...
            if restriction.capacity_restriction
                # ...Order.capacity_status updaten
                new_tour = update_capacity(new_tour_index_first)
            end
            
            # Delivery in new_tour einsetzen
            new_tour.for_each_with_index do |location_second, index_second|
                # Abbrechen bevor nach home eingesetzt wird
                if index_second+1 == new_tour.length
                    break
                end
                # Delivery erst nach Pickup einsetzen 
                if index_second > index_first+1
                    #Delivery einsetzen
                    new_tour.insert(index_second+1, order_tour_delivery)
                    
                    # OrderTour.time updaten
                    new_tour = update_time(new_tour, index_second+1)
                    # Wenn eine Capacity_restriction besteht...
                    if restriction.capacity_restriction
                        # ...Order.capacity_status updaten
                        new_tour = update_capacity(new_tour, index_second+1)
                    end
                    # Prüfen ob Beschränkungen eingehalten werden
                    if check_restriction(new_tour, order, driver)
                        break
                    end   
                end
                
                # Depot als letztes vor home einsetzen, zum Entladen
                depot = create_depot()
                depot.capacity = old.tour[tour.length-2].capacity_status*-1 # Fahrzeug wird entladen
                old_tour.insert(old_tour.length-2 , depot)
                
                # best_tour = erste new_tour
                if best_tour.length < new_tour.length
                    best_tour = duplicate_tour_array(new_tour)
                else # wenn das schon passiert ist...
                    # ...überprüfen ob die neue tour kürzer ist als die vorherige
                    if calc_tour_time(new_tour) < calc_tour_time(best_tour)
                        best_tour = duplicate_tour_array(new_tour)
                    end
                end
            end
        end
        best_tour # return
    end # end insertion_pdp()
    
    #FIXME
    #Insertionalgo für DP
    def insertion_dp(order, driver)
        # load tour vom driver (wenn eine besteht)
        old_tour = []
        # Alle OrderTour Elemente laden und old_tour befüllen
        OrderTour.where(tour_id: driver.tour_id).find_each do |tour_element|
            old_tour.push(tour_elemnt)
        end
        
        #Wenn es keine alte Tour gab, neue Tour vorbereiten
        if old_tour.empty?
            # startpostion einfügen
            vehicle_position = create_vehicle_position(driver)
            old_tour.push(vehicle_position)
            # Depot einsetzen - zum Beladen des Fahrzeuges
            depot = create_depot()
            depot.capacity = driver.capacity # Fahrzeug wird voll beladen
            old_tour.push(depot)
            # home einfügen - entspricht unternehmensadresse
            home = create_home(vehicle_position, driver)
            old_tour.push(home)
        end
        
        # Delivery OrderTour
        order_tour_delivery = create_delivery(order)
        
        # Array für beste tour
        best_tour = []
        
        # OrderTour an verschiedenen Positionen einsetzen
        old_tour.for_each_with_index do |location, index|
            # Abbrechen bevor nach home eingesetzt wird
            if index+1 == old_tour.length
                break
            end
                
            # Potenziell neue Tour erstellen
            new_tour = duplicate_tour_array(old_tour) 
            
            # Delivery einsetzen
            new_tour.insert(index+1, order_tour_delivery)

            # OrderTour.time updaten
            new_tour = update_time(new_tour, index+1)
            # Wenn eine Capacity_restriction besteht...
            if restriction.capacity_restriction
                # ...Order.capacity_status updaten
                new_tour = update_capacity(new_tour, index)
            end
            
            # Prüfen ob Beschränkungen eingehalten werden
            if check_restriction(new_tour, order, driver)
                break
            end

            # best_tour mit ersten new_tour befüllen
            if best_tour.length < new_tour.length
                best_tour = duplicate_tour_array(new_tour)
            else # wenn das schon passiert ist...
                # ...überprüfen ob die neue tour kürzer ist als die vorherige
                if calc_tour_time(new_tour) < calc_tour_time(best_tour)
                    best_tour = duplicate_tour_array(new_tour)
                end
            end
        end
        best_tour # return
    end # end insertion_dp()
    
    #FIXME
    #Insertionalgo für PP
    def insertion_pp(order, driver)
        # Ggf einhalten von time_window?(), capacity?(), working_time?()
        # load tour vom driver (wenn eine besteht)
        old_tour = []
        # Alle OrderTour Elemente laden und old_tour befüllen
        OrderTour.where(tour_id: driver.tour_id).find_each do |tour_element|
            old_tour.push(tour_elemnt)
        end
        
        # Pickup OrderTour 
        order_tour_pickup = create_pickup(order)
        
        # OrderTour an verschiedenen Positionen einsetzen
        old_tour.for_each_with_index do |location, index|
            # Abbrechen bevor nach home eingesetzt wird
            if index+1 == old_tour.length
                break
            end
            
            #potenziell neue Tour erstellen
            new_tour = duplicate_tour_array(old_tour) 
            
            # Pickup einsetzen
            new_tour.insert(index+1, order_tour_pickup)
            
            # OrderTour.time updaten
            new_tour = update_time(new_tour, index+1)
            # Wenn eine Capacity_restriction besteht...
            if restriction.capacity_restriction
                # ...Order.capacity_status updaten
                new_tour = update_capacity(new_tour, index)
            end
            
            # Prüfen ob Beschränkungen eingehalten werden
            if check_restriction(new_tour, order, driver)
                break
            end
           
        end
        tour # return
    end # end insertion_pp()
    
    #DONE
    #Orders in Gruppen nach den Priorities einteilen
    def by_priority()
        prioA=[]
        prioB=[]
        prioC=[]
        prioD=[]
        orders.each do |order|
            if order.customer.priority = "A"
                prioA.push(order)
            elsif order.customer.priority = "B"
                prioB.push(order)
            elsif order.customer.priority = "C"
                prioC.push(order)
            else # Prio "D" oder null oder Eingabefehler
                prioD.push(order)
            end
        end
        prioArray =[prioA, prioB, prioC. prioD]
        prioArray # return
    end # end by_priority()
    
    #DONE
    # erstellt zu order ein ordertour vom typ pickup
    def create_pickup(order)
        order_tour_pickup = OrderTour.new # FIXME geht das?
        # user_id wird in commit gesetzt
        order_tour_pickup.order_id = order.id
        # tour_id wird in commit gesetzt
        # company_id wird in commit gesetzt
        order_tour_pickup.location = order.pickup_location
        # place (Plazierung) wird im commit gesetzt
        order_tour_pickup.comment = order.comment
        order_tour_pickup.type = "pickup"
        order_tour_pickup.capacity = order.capacity
        # capacity_status (Ladestatus Fahrzeug) wird im algo gesetzt
        # time wird im Algo gesetzt
        order_tour_pickup.duration = order.duration_pickup
        # latitude/longitude werden von Geocoder gesetzt
        order_tour_pickup # return
    end # end create_pickup
    
    #DONE
    # erstellt zu order ein ordertour vom typ delivery
    def create_delivery(order)
        order_tour_delivery = OrderTour.new # FIXME geht das?
        # user_id wird in commit gesetzt
        order_tour_delivery.order_id = order.id
        # tour_id wird in commit gesetzt
        # company_id wird in commit gesetzt
        order_tour_delivery.location = order.delivery_location
        # place (Plazierung) wird im commit gesetzt
        order_tour_delivery.comment = order.comment
        order_tour_delivery.type = "delivery"
        order_tour_delivery.capacity = order.capacity*-1 # negativ weil entladen wird
        # capacity_status (Ladestatus Fahrzeug) wird im algo gesetzt
        # time wird im Algo gesetzt
        order_tour_delivery.duration = order.duration_delivery
        # latitude/longitude werden von Geocoder gesetzt
        order_tour_delivery # return
    end # end create_delivery
    
    # DONE
    # erstellt OrderTour für vp driver
    def create_vehicle_position(driver)    
        # carrier.vehicle.position einsetzen als OrderTour
        vehicle_position = OrderTour.new
        # user_id wird in commit gesetzt
        vehicle_position.order_id = nil
        # tour_id wird in commit gesetzt
        # company_id wird in commit gesetzt
        vehicle_position.location = driver.vehicle.position
        # place (Platzierung) wird im commit gesetzt
        vehicle_position.comment = nil
        vehicle_position.type = "position"
        vehicle_position.capacity = 0
        vehicle_position.capacity_status = 0
        vehicle_position.time = 0 # Keine Zeit vergangen
        vehicle_position.duration = 0 # Keine Zeit benötigt
        # latitude/longitude werden von Geocoder gesetzt
        vehicle_position # return
    end # end create_vehicle_position
    
    # DONE
    # erstellt OrderTour home für driver
    def create_home(verhicle_position, driver)
        # home = company.address
        home = OrderTour.new
        # user_id wird in commit gesetzt
        home.order_id = nil
        # tour_id wird in commit gesetzt
        # company_id wird in commit gesetzt
        home.location = driver.vehicle.position
        # place (Platzierung) wird im commit gesetzt
        home.comment = nil
        home.type = "home"
        home.capacity = 0
        # capacity_status (Ladestatus Fahrzeug) wird im algo gesetzt
        home.time = time_for_distance(vehicle_position, home)
        home.duration = 0 # Keine Zeit benötigt
        # latitude/longitude werden von Geocoder gesetzt
        home # return
    end # end create_home
    
    #FIXME
    # erstellt OrderTour depot
    def create_depot()
        # depot = company.depot
        depot = OrderTour.new
        # user_id wird in commit gesetzt
        depot.order_id = nil
        # tour_id wird in commit gesetzt
        # company_id wird in commit gesetzt
        depot.location = company.depot.address
        # place wird in commit gesetzt
        depot.comment = "Warenbestand auffüllen"
        depot.type = "depot"
        # Cpacity wird im Algo gesetzt - Fahrzeug soll voll beladen oder entladen werden
        # capacity_status wird in algo gesetzt
        # time wird im Algo gesetzt
        depot.duration = company.depot.duration
        # latitude/longitude werden von Geocoder gesetzt
        depot # return
    end # end create_depot()
    
    #FIXME
    # Berechnet die Zeit für die Fahrt von order_tour1 nach order_tour2
    def time_for_distance(ot1, ot2)
        # per geocode, Nominatim die Fahrzeit zwischen ot1.lat / long und ot2.lat / long herausfinden
        # eine Anfrage pro Sekunde!
        10 # return 10min für alle
    end# end time_for_distance()
    
    # FIXME
    # Überprüft für die tour ob die Beschränkungen eingehalten werden
    def check_restriction(tour,order,driver)
        # Check
        if company.restriction.time_window
            if time_window?(tour, order, driver)
                return true
            end
        end
        
        #FIXME Depots einfügen
        if company.restriction.capacity_restriction
            if capacity?(tour, driver)
                    return true
            end
        end
              
        if company.restriction.working_time
            if working_time?(tour, driver)
                return true
            end
        end
        false # liefert true, wenn alle Beschränkungen eingehalten werden
    end # end check_restriction()
    
    #FIXME - Depots einsetzen
    # Überprüfen ob Capacity restricion eingehalten wird und setzt ggf. Depots ein
    def capacity?(tour, driver) # liefert true, wenn gegen restriction verstoßen wird
        tour.for_each_with_index do |order_tour, index|
            # Wenn eine bei einem Punkt in Tour die Capacity überschritten wird
            if order_tour.capacity_status > driver.vehicle.capacity 
                if company.restriction == "PP" # Und es ein PP ist,...
                    #... dann soll ein Depot davor eingesetzt werden
                    depot = create_depot()
                    # Fahrzeug komplett entleeren
                    depot.capacity = tour[index-1]*-1
                    # Vor Verstoß einsetzen
                    tour.insert(index-1, depot)
                    # FIXME update capacity_status
                else
                    return true # Wenn es PDP ist, dann Verstoß
                end
            elsif order_tour.capacity_status <= 0  # oder kleiner, gleich 0 ist
                if company.restriction == "DP" # Und es ein DP ist,...
                    #... dann soll ein Depot davor eingesetzt werden
                    depot = create_depot()
                    # Fahrzeug vollbeladen
                    depot.capacity = driver.capacity - tour[index-1]
                    # Vor Verstoß einsetzen
                    tour.insert(index-1, depot)
                    # Capacity_status updaten
                    tour = update_capacity(tour, index)
                else
                    return true # Wenn es PDP ist, dann Verstoß
                end
            end
        end
        # ...sonst false
        return false
    end # end capacity?()
    
    #FIXME - Warten um eine Order einsetzen zu können
    # Überprüfen ob Time Windows eingehalten werden
    def time_window?(tour, order, driver) # liefert true, wenn gegen restriction verstoßen wird
        # Uhrzeit von jetzt bis OrderTour von Order prüfen
        # Wenn die Uhrzeit < order.start_time
        # return true -> Pickup ist zu früh
        # Wenn PDP
        # Prüfen ob der Delivery nach order.end_time ist
        # return true -> Delivery ist zu spät
        
                    
        # FIXME - wenn durch time_window keine zulässige Tour gebildet werden konnte
        # dann an die matrix eintragen, dass es nicht geht durch sehr lange duration
            
    end
    
    #DONE
    # Überprüfen ob working time eingehalten wird
    def working_time?(tour, driver) # liefert true, wenn gegen restriction verstoßen wird
        # Prüfen ob die Tourdauer > als working_time vom Driver
        if calc_tour_time(tour) > driver.working_time
            # true wenn tour zu lang ist
            return true
        end
        return false
    end # end working_time?()
    
    #DONE
    # Berechnet OrderTour.time neu
    def update_time(tour, index)
        # OrderTour.time setzen
        tour(index).time = time_for_distance(new_tour(index-1), new_tour(index))
        #... und das nächste Element
        tour(index+1).time = time_for_distance(new_tour(index), new_tour(index_first+1))
        
        tour # return
    end
    
    #DONE
    # Berechnet OrderTour.capacity_status neu für alle OrderTours ab index
    def update_capacity(tour, index)
        # OrderTour.capacity_status setzen für Pickup-Element...
        tour(index).capacity_status = tour(index-1).capacity_status + tour(index).capacity
        # OrderTour.capacity_status für alle Nachfolgenden setzen
        tour.for_each_with_index do |order_tour, index2|
            # erst nach neuem element updaten
            if index2 > index
                order_tour.capacity_status = new_tour(index2-1).capacity_status + new_tour(index2).capacity
            end
        end 
        
        tour # return
    end
    
    #DONE
    # erzeugt echte Copy von Array
    def duplicate_tour_array (tour)
        new_tour = []
        tour.each do |element|
            # FIXME - Jedes Element neu erstellen und kopieren
            new_tour.push(element.clone)
        end
        new_tour
    end# end duplicate_tour_array()
    
    #DONE
    # gibt die Zeit für die gesamte Tour zurück
    def calc_tour_time(tour)
        tour_time = 0
        tour.each do |order_tour|
            tour_time += order_tour.time # Fahrzeit
            tour_time += order_tour.duration # Arbeitszeit
        end
        tour_time # return
    end# end calc_tour_time()
end