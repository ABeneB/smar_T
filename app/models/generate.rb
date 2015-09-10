#Klasse zur Erstellung der Touren entsprechen der Konfiguration

#Ideas : durch OrderTour.time kann man herausfinden wie lange man von der vorherigen location zu dieser braucht. Dadruch weniger anfragen an Maps,
# denn man muss für jede Einsetzung nur die time vom eignen und nächsten location updaten und die nummerirung aller nachfolgenden orderTour +1

class Generate
    
    #Variablen
    attr_accessor :drivers, :orders, :company, :user
    
    #Methoden
    #DONE
    # generiete die Touren für alle driver und orders entsprechend der restrictions von Unternehmen
    def generate_tours()
        # Prüfen ob Prioritätsstufen bestehen
        if restrictions.priority
            # orders ändern zu array von arrays, für jede priority eine array
            orders = by_priority()
            i = 0
            # Jedes array in orders nacheiander lösen
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
            commit_order(driver, tour)
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
    def commit_order(driver, tour)
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
            # OrderTours_Pickup einsetzen in tour an Stelle index_first+1
            # index_first + 1, damit nicht vor vehicle_position eingesetzt wird
            # Pickup einsetzen
            new_tour.insert(index_first+1, order_tour_pickup)
            #FIXME
            # Pickup OrderTour.time setzen
            new_tour(index_first+1).time = time_for_distance(new_tour(index_first), new_tour(index_first+1))
            # Pickup OrderTour.capacity_status setzen
            new_tour(index_first+1).capacity_status = new_tour(index_first).capacity_status + new_tour(index_first+1).capcity
            # OrderTour.capacity_status für alle Nachfolgenden setzen
            new_tour.for_each_with_index do |order_tour, index|
                # erst nach neuem element
                if index == index_first+2
                    new_tour(index_first+1).capacity_status = new_tour(index_first).capacity_status + new_tour(index_first+1).capcity
                end
            end
            
            # bis zur neuen OrderTour in new_tour nichts ändern
            # bei Order Tour die Fahrzeit von vorheriger zur neuen berechnen
            # Fahrzeit + pickup_duration + vorherige OrderTour.time = OrderTour.time
            # OrderTour.capacity_status für jede OrderTour setzen
            
            # Pickup in new_tour einsetzen
            new_tour.for_each_with_index do |location_secound, index_secound|
                # Abbrechen beovr nach home eingesetzt wird
                if index_secound+1 == new_tour.length
                    break
                end
                
                # zweite OrderTours einsetzen wenn index_secound == index_first
                # Nach index_first einsetzen
                if index_secound > index_first+1
                    #Einsetzen von delivery
                    new_tour.insert(index_secound+1, order_tour_delivery)
                    # OrderTour.time für jede OrderTour setzen
                    # bis zur neuen OrderTour in new_tour nichts ändern
                    # bei Order Tour die Fahrzeit von vorheriger zur neuen berechnen
                    # Fahrzeit + pickup_duration + vorherige OrderTour.time = OrderTour.time
                    # OrderTour.capacity_status für jede OrderTour setzen
                    
                    # prüft restriction und bricht ab, wenn gegen restriction verstoßen wird
                    if restrictions.time_window
                        if time_window?(new_tour, order, driver)
                            break
                        end
                    end
                    
                    # prüft restriction und bricht ab, wenn gegen restriction verstoßen wird
                    if restrictions.capacity_restriction
                        if capcity?(new_tour, driver)
                            break
                        end
                    end
                    
                    # prüft restriction und bricht ab, wenn gegen restriction verstoßen wird
                    if restrictions.working_time
                        if working_time?(new_tour, driver)
                            break
                        end
                    end    
                end
                duration = #neue duration
                # überprüfen ob die neue duration < old_tour[0] (alte duration)
                if duration < old_tour[0]
                    tour.unshift(duration)
                    best_tour = duplicate_tour_array(new_tour)
                end
            end
        end
        best_tour # return - tour ist array OrderTour-Objekte in Reihenfolge + als erstes die duration
    end # end insertion_pdp()
    
    #FIXME
    #Insertionalgo für DP
    def insertion_dp(order, driver)
        # Ggf einhalten von time_window?(), capcity?(), working_time?()
        # load tour vom driver (wenn eine besteht)
        old_tour = []
        # Alle OrderTour Elemente laden und old_tour befüllen
        OrderTour.where(tour_id: driver.tour_id).find_each do |tour_element|
            old_tour.push(tour_elemnt)
        end
        
        # Delivery OrderTour
        order_tour_delivery = create_delivery(order)
        
        # OrderTour an verschiedenen Positionen einsetzen
        old_tour.for_each_with_index do |location, index|
            # Abbrechen bevor nach home eingesetzt wird
            if index+1 == old_tour.length
                break
            end
                
            #potenziell neue Tour erstellen
            new_tour = duplicate_tour_array(old_tour) 
            
            # Delivery einsetzen
            new_tour.insert(index+1, order_tour_delivery)
            # OrderTour.time für jede OrderTour setzen
            # bis zur neuen OrderTour in new_tour nichts ändern
            # bei Order Tour die Fahrzeit von vorheriger zur neuen berechnen
            # Fahrzeit + pickup_duration + vorherige OrderTour.time = OrderTour.time
            # OrderTour.capacity_status für jede OrderTour setzen
            
            # prüft restriction und bricht ab, wenn gegen restriction verstoßen wird
            if restrictions.time_window
                if time_window?(new_tour, order, driver)
                    break
                end
            end
            
            # prüft restriction und bricht ab, wenn gegen restriction verstoßen wird    
            if restrictions.capacity_restriction
                if capcity?(new_tour, driver)
                    break
                end
            end
            
            # prüft restriction und bricht ab, wenn gegen restriction verstoßen wird 
            if restrictions.working_time
                if working_time?(new_tour, driver)
                    break
                end
            end
            
        end
        
        tour # return - tour ist array OrderTour-Objekte in Reihenfolge + als erstes die duration
    end # end insertion_dp()
    
    #FIXME
    #Insertionalgo für PP
    def insertion_pp(order, driver)
        # Ggf einhalten von time_window?(), capcity?(), working_time?()
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
            # OrderTour.time für jede OrderTour setzen
            # bis zur neuen OrderTour in new_tour nichts ändern
            # bei Order Tour die Fahrzeit von vorheriger zur neuen berechnen
            # Fahrzeit + pickup_duration + vorherige OrderTour.time = OrderTour.time
            # OrderTour.capacity_status für jede OrderTour setzen
            
            # prüft restriction und bricht ab, wenn gegen restriction verstoßen wird
            if restrictions.time_window
                if time_window?(new_tour, order, driver)
                    break
                end
            end
            
            # prüft restriction und bricht ab, wenn gegen restriction verstoßen wird    
            if restrictions.capacity_restriction
                if capcity?(new_tour, driver)
                    break
                end
            end
              
            # prüft restriction und bricht ab, wenn gegen restriction verstoßen wird  
            if restrictions.working_time
                if working_time?(new_tour, driver)
                    break
                end
            end
        end
        
        tour # return - tourobjekt und array OrderTour-Objekte in Reihenfolge + als erstes die duration
    end # end insertion_pp()
    
    #DONE
    # Überprüfen ob Capacity restricion eingehalten wird
    def capcity?(tour, driver) # liefert true, wenn gegen restriction verstoßen wird
        tour.each do |order_tour|
            # Wenn eine bei einem Punkt in Tour die Capacity überschritten wird...
            if order_tour.capacity_status > driver.vehicle.capcity
                # dann true zurück geben,...
                return true # FIXME ist das auch gleichzeitig break? - soll nicht mehr weiter iterieren
            end
        end
        # ...sonst false
        return false
    end # end capcity?()
    
    # Überprüfen ob Time Windows eingehalten werden
    def time_window?(tour, order, driver) # liefert true, wenn gegen restriction verstoßen wird
        
    end
    
    #DONE
    # Überprüfen ob working time eingehalten wird
    def working_time?(tour, driver) # liefert true, wenn gegen restriction verstoßen wird
        # Prüfen ob die Tourdauer (.time letztes Element)> als working_time vom Driver
        if tour[tour.length-1].time > driver.working_time
            # true wenn tour zu lang ist
            return true
        end
        return false
    end # end working_time?()
    
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
        order_tour_pickup.capcity = order.capcity
        # capacity_status (Ladestatus Fahrzeug) wird im algo gesetzt
        # time wird im Algo gesetzt
        order_tour_pickup.duration = order.duration_pickup
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
        order_tour_delivery.capcity = order.capcity*-1 # negativ weil entladen wird
        # capacity_status (Ladestatus Fahrzeug) wird im algo gesetzt
        # time wird im Algo gesetzt
        order_tour_delivery.duration = order.duration_delivery
        order_tour_delivery # return
    end # end create_delivery
    
    # DONE
    # erstellt OrderTour für driver
    def create_vehicle_position(driver)    
        # carrier.vehicle.position einsetzen als OrderTour
        vehicle_position = OrderTour.new
        # user_id wird in commit gesetzt
        vehicle_position.order_id = nil
        # tour_id wird in commit gesetzt
        # company_id wird in commit gesetzt
        vehicle_position.location = driver.vehicle.position
        set_lat_long(vehicle_position)
        # place (Platzierung) wird im commit gesetzt
        vehicle_position.comment = nil
        vehicle_position.type = "position"
        vehicle_position.capcity = 0
        # capacity_status (Ladestatus Fahrzeug) wird im algo gesetzt
        vehicle_position.time = 0 # Keine Zeit vergangen
        vehicle_position.duration = 0 # Keine Zeit benötigt
        vehicle_position # return
    end # end create_vehicle_position
    
    # DONE
    # erstellt OrderTour für driver
    def create_home(verhicle_position, driver)
        # home = company.address
        home = OrderTour.new
        # user_id wird in commit gesetzt
        home.order_id = nil
        # tour_id wird in commit gesetzt
        # company_id wird in commit gesetzt
        home.location = driver.vehicle.position
        set_lat_long(home)
        # place (Platzierung) wird im commit gesetzt
        home.comment = nil
        home.type = "home"
        home.capcity = 0
        # capacity_status (Ladestatus Fahrzeug) wird im algo gesetzt
        home.time = time_for_distance(vehicle_position, home)
        home.duration = 0 # Keine Zeit benötigt
        home # return
    end # end create_home
    
    
    #FIXME
    # address zu latitude, longitude umrechnen
    def set_lat_long(order_tour)
        # per Geocide umwandeln von adress zu latitude und logitude
    end
    
    #FIXME
    # Berechnet die Zeit für die Fahrt von order_tour1 nach order_tour2
    def time_for_distance(ot1, ot2)
        # per geocode, Nominatim die Fahrzeit zwischen ot1.lat / long und ot2.lat / long herausfinden
    end# end time_for_distance()
    
    #FIXME
    # erzeugt echte Copy von Array
    def duplicate_tour_array (tour)
        new_tour = []
        tour.each do |element|
            # FIXME - Jedes Element neu erstellen und kopieren
            new_tour.push(element.clone)
        end
        new_tour
    end# end duplicate_tour_array()
    
    # gibt die Zeit für die Tour zurück
    def calc_tour_time(tour)
        duration = 0
        tour.each do |order_tour|
            duration += order_tour.time # Fahrzeit
            duration += order_tour.duration # Arbeitszeit
        end
        duration # return
    end# end calc_tour_time()
end