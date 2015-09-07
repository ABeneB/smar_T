#Klasse zur Erstellung der Touren entsprechen der Konfiguration

#Ideas : durch OrderTour.time kann man herausfinden wie lange man von der vorherigen location zu dieser braucht. Dadruch weniger anfragen an Maps,
# denn man muss für jede Einsetzung nur die time vom eignen und nächsten location updaten und die nummerirung aller nachfolgenden orderTour +1


class Generate
    
    #Speichern der company.restrictions
    restrictions

    # generiete die Touren für alle driver und orders entsprechend der restrictions von Unternehmen
    def generate_tour(drivers, orders, company)
        # Restrictions speichern für insertion algo
        restrictions = company.restrictions
        
        # Prüfen ob Prioritätsstufen bestehen
        if restrictions.priority
            # orders ändern zu array von arrays, für jede priority eine array
            orders = by_priority(orders)
            i = 0
            # Jedes array in orders nacheiander lösen
            while i < orders.length do
                # Matrix für jede Prioritässtufe
                matrix = build_matrix(orders[i], drivers)
                # jede Prioritätsstufe nacheinander bearbeiten
                solve_matrix(orders[i])
                i += 1
            end
        else # keine Prioritätsstufen
            # Matrix zwischen allen Drivern und allen Orders aufspannen
            matrix = build_matrix(orders, drivers)
            # Alle Orders in Matrix zuteilen 
            solve_matrix(matrix)
        end
        
    end # end generate_tour()
    
    # Matrix für Drivers und Orders
    def build_matrix(orders,drivers)
        matrix = []
        tour_time = [] # FIXME - Objekt? - Klasse dafür schreiben
        # MV oder SV wird autoamtisch durch die Anzahl von Drivern in Drivers beachtet
        # für jede Order...
        orders.each do |order|
            #... jeden Driver
            drivers.each do |driver|
                # die Zeit, samt Driver und Order, in tourtime speichern
                tour_time.push(driver)
                tour_time.push(order)
                # die tour einfügen
                tour_time.push(build_tour_order(order,driver))
                # anschließend in die matrix pushen
                matrix.push(tour_time)
            end
        end
        matrix #return
    end
    
    # MMM durchführen und touren bilden
    def solve_matrix(matrix)
        shortest_tour = matrix[0] # erste tour einfügen
        # schnellste Tour ermitteln
        matrix.each do |tour_time|
        # tour ist im dritten element im array array[2]
            if shortest_tour[2][0] > tour_time[2][0]
                shortest_tour = tour_time # FIXME - clone?
            end
        end
        # leserlicher umspeichern
        driver = shortest_tour_time[0]
        order = shortest_tour_time[1]
        tour = shortest_tour_time[2]
        # Driver die Order zuteilen
        commit_order(driver, tour)
        #update matrix - löschen aller einträge mit der Order und die Zeiten vom Fahrer updaten
        update_matrix(matrix, driver, order)
    end
    
    # liefert benötigte Zeit eines Drivers für Order
    def build_tour(order, driver)
        # Entsprechend dem Tourenplanungsproblem den Insertionalgorithmus aufrufen
        if unternehmen.restriction.problem == "PDP"
           tour = insertion_pdp(order, driver)
        elsif unternehmen.restriction.problem == "DP"
            tour = insertion_dp(order, driver)
        elsif unternehmen.restriction.problem == "PP"
            tour = insertion_pp(order, driver)
        end
        tour # return zeit
    end # end build_tour_order()
    
    #Insertionalgo für PDP
    def insertion_pdp(order, driver)
        # load tour of driver 
        tour = []
        TourOrder.where(tour_id: driver.tour_id).find_each do |tour_order|
            tour.push(tour_order)
        end
        # Order in zwei OrderTours zerlegen
        best_tour = []
        # OrderTours an verschiedenen Positionen einsetzen
        tour.for_each_with_index do |location_first, index_first|
            #potenziell neue Tour erstellen
            new_tour = tour.clone # FIXME - clone notwendig?
            #erste OrderTours einsetzen in tour an Stelle index_first
            
            tour.for_each_with_index do |location_secound, index_secound|
                #zweite OrderTours einsetzen wenn index_secound == index_first
                #Ggf Einhaltung von time_window?(), capcity?(), working_time?() überprüfen
                if restrictions.time_window
                    if time_window?()
                        break
                    end
                end
                
                if restrictions.capacity_restriction
                    if capcity?()
                        break
                    end
                end
                
                if restrictions.working_time
                    if working_time?()
                        break
                    end
                end
            duration = #neue duration
            # überprüfen ob die neue duration < old_tour[0] (alte duration)
            if duration < old_tour[0]
                tour.unshift(duration)
                best_tour = new_tour.clone # FIXME - clone notwendig?
            end
            end
        end
        
        tour # return - tour ist array OrderTour-Objekte in Reihenfolge + als erstes die duration
    end # end insertion_pdp()
    
    #Insertionalgo für DP
    def insertion_dp(order, driver)
        #Ggf einhalten von time_window?(), capcity?(), working_time?()
        
        tour # return - tour ist array OrderTour-Objekte in Reihenfolge + als erstes die duration
    end # end insertion_dp()
    
    #Insertionalgo für PP
    def insertion_pp(order, driver)
        #Ggf einhalten von time_window?(), capcity?(), working_time?()
        
        tour # return - tourobjekt und array OrderTour-Objekte in Reihenfolge + als erstes die duration
    end # end insertion_pp()
    
    # Überprüfen ob Capacity restricion eingehalten wird
    def capcity?()
        
    end # end capcity?()
    
    # Überprüfen ob Time Windows eingehalten werden
    def time_window?()
        
    end
    
    # Überprüfen ob working time eingehalten wird
    def working_time?()
        
    end # end working_time?()
    
    #Orders in Gruppen nach den Priorities einteilen
    def by_priority(orders)
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
    
    # Order final in Tour einsetzen, Duration updaten
    def commit_order(driver, tour)
        # aus OrderTour erzeugen entsprchend der tour
        # tour sollte alle orderTour objekte enthalten
        # Driver und Tour an OrderTour anfügen
    end # end commit_order()
    
    # Nach einer Zuteilung die matrix erneuern
    def update_matrix(matrix, order, driver)
        
        matrix # return
    end # end update_matrix()
end