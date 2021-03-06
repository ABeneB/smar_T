class OrderToursController < ApplicationController
  before_action :set_order_tour, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if current_user && current_user.is_admin?
      @order_tours = OrderTour.all
    end
  end

  def show
    if current_user && current_user.is_admin?
      @order_tour
    end
  end

  def new
    if current_user && current_user.is_admin?
      @order_tour = OrderTour.new
    end
  end

  def edit
    # FIXME
  end

  def create
    @order_tour = OrderTour.new(order_tour_params)
    @order_tour.save
  end

  def update
    @order_tour.update(order_tour_params)
  end

  def destroy
    @order_tour.destroy
  end

  # updates the order of the order_tours inside a tour
  # is called by the user (front-end, ajax)
  # receives an array of order ids
  def update_positions
    orderTourIds = params[:orderTour]
    index = 2
    orderTourIds.each do |id|
      orderTour = OrderTour.find(id)
      unless orderTour.nil?
        orderTour.place = index
        orderTour.save
        index = index + 1
      end
    end
    redirect_to action: "index"
  end

  private
    def set_order_tour
      @order_tour = OrderTour.find(params[:id])
    end

    def order_tour_params
      params.require(:order_tour).permit(:user_id, :order_id, :tour_id, :company_id, :location, :place)
    end
end
