class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @tours = Tour.all
    respond_with(@tours)
  end

  def show
    respond_with(@tour)
  end

  def new
    @tour = Tour.new
    respond_with(@tour)
  end

  def edit
  end

  def create
    @tour = Tour.new(tour_params)
    @tour.save
    respond_with(@tour)
  end

  def update
    @tour.update(tour_params)
    respond_with(@tour)
  end

  def destroy
    @tour.destroy
    respond_with(@tour)
  end

  private
    def set_tour
      @tour = Tour.find(params[:id])
    end

    def tour_params
      params.require(:tour).permit(:user_id, :driver_id, :company_id, :duration)
    end
end
