module ToursHelper

  def self.get_algorithm_display_text(algorithm)

    if algorithm == AlgorithmEnum::M3PDP
      display_text = "M3PDP"
    elsif algorithm == AlgorithmEnum::M3PDPDELTA
      display_text = "M3PDP Delta"
    elsif algorithm == AlgorithmEnum::SAVINGSPP
      display_text = "Savings++"
    end

    display_text

  end

  def self.is_sortable_order_tour?(order_tour)

    sortable_class = order_tour.kind != "delivery" ? false : true
    sortable_class

  end

end
