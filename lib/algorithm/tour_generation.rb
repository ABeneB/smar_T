require 'algorithm/variants/savingsplusplus'

module Algorithm

  class TourGeneration

    def self.generate_tours(company)
      orders, drivers  = preprocess(company.orders, company.drivers)

      # classic_m3tp = ClassicMThreeTP.new
      # delta_m3tp = DeltaMThreeTP.new
      savingsplusplus = Variants::SavingsPlusPlus.new(company)
      savingsplusplus.run(orders, drivers)


    end


    def self.preprocess(all_orders, all_drivers)
      orders = preprocess_orders(all_orders)
      #only active drivers
      drivers = all_drivers.where(activ: true)
      return orders, drivers
    end

    def self.preprocess_orders(all_orders)
      active_orders = all_orders.where(activ: true)
      orders = []
      active_orders.each do |order|
        if !order.start_time || order.start_time.try(:today?)
          orders.push(order)
        end
      end
      #sort orders by start_time ascending and put orders with nil start_time at the end
      orders.sort_by! { |order| [order.start_time ? 0 : 1, order.start_time] }
      orders
    end

    def self.compare_results()

    end
  end
end
