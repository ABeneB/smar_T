class OrderToursController < ApplicationController
  before_action :set_order_tour, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_tours = OrderTour.all
    respond_with(@order_tours)
  end

  def show
    respond_with(@order_tour)
  end

  def new
    @order_tour = OrderTour.new
    respond_with(@order_tour)
  end

  def edit
  end

  def create
    @order_tour = OrderTour.new(order_tour_params)
    @order_tour.save
    respond_with(@order_tour)
  end

  def update
    @order_tour.update(order_tour_params)
    respond_with(@order_tour)
  end

  def destroy
    @order_tour.destroy
    respond_with(@order_tour)
  end

  private
    def set_order_tour
      @order_tour = OrderTour.find(params[:id])
    end

    def order_tour_params
      params.require(:order_tour).permit(:user_id, :order_id, :tour_id, :company_id, :location, :place)
    end
end
