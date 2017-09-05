require 'algorithm/variants/savingsplusplus'
require 'algorithm/variants/classic_mthreetp'

module Algorithm

  class TourGeneration

    def self.generate_tours(company)
      orders, drivers  = preprocess(company.orders, company.drivers)

      # classic M3-PDP
      classic_m3pdp = Variants::ClassicMThreeTP.new(company, AlgorithmEnum::M3PDP)
      classic_m3pdp.run(orders, drivers)

      # delta M3-PDP
      #delta_m3pdp = Variants::ClassicMThreeTP.new(company, AlgorithmEnum::M3PDPDELTA)
      #delta_m3pdp.run(orders, drivers)

      # Savings++ Algorithm
      # savingsplusplus = Variants::SavingsPlusPlus.new(company)
      # savingsplusplus.run(orders, drivers)

      #compare_and_save_tours()
    end


    def self.preprocess(all_orders, all_drivers)
      orders = preprocess_orders(all_orders)
      #only active drivers
      drivers = all_drivers.where(active: true).to_a
      return orders, drivers
    end

    def self.preprocess_orders(all_orders)
      active_orders = all_orders.where(active: true)
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

    def self.compare_and_save_tours()
      tours_duration = Array.new(3)

      m3pdp_tours = Tour.where(status: StatusEnum::GENERATED, algorithm: AlgorithmEnum::M3PDP)
      m3pdp_delta_tours = Tour.where(status: StatusEnum::GENERATED, algorithm: AlgorithmEnum::M3PDPDELTA)
      saving_tours = Tour.where(status: StatusEnum::GENERATED, algorithm: AlgorithmEnum::SAVINGSPP)

      tours_duration[AlgorithmEnum::M3PDP] = m3pdp_tours.inject(0){ |sum, x| sum + x.duration }
      tours_duration[AlgorithmEnum::M3PDPDELTA] = m3pdp_delta_tours.inject(0){ |sum, x| sum + x.duration}
      tours_duration[AlgorithmEnum::SAVINGSPP] = saving_tours.inject(0){ |sum, x| sum + x.duration }

      best_algorithm_index = tours_duration.each_with_index.min[1] # index of the min value in array

      Tour.where(status: StatusEnum::GENERATED).where.not(algorithm: best_algorithm_index).destroy_all
    end
  end
end
