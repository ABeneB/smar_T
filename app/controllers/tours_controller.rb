class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    # Nur Daten die Zur Rolle passen anzeigen
    if current_user.is_admin?
      @tours = Tour.all
    elsif current_user.is_driver?
      company = current_user.company
      @tours = Tour.where(company_id: company.id)
    elsif current_user.is_planer?
      company = current_user.company
      @tours = Tour.where(company_id: company.id)
    else
      @tours = []
    end
  end

  def show
    @order_tours = @tour.order_tours
    @hash = @order_tours.map do | order_tour|
      {latitude: order_tour.latitude, longitude: order_tour.longitude, place: order_tour.place.to_s}
    end
    respond_with(@tour, @hash)
  end

  def new
    # Orders, Drivers und Company filter/suchen
    user = User.find(current_user.id)
    g = Generate.new
    g.drivers = user.company.drivers.where(activ: true)
    g.orders = user.company.orders.where(activ: true)
    g.company = user.company
    g.user = user
    
    # Generate erzeugt und speichert die neuen Touren, OrderTour-Objekte
    g.generate_tours
    
    #Ausgabe nach Rolle filtern
    if current_user.is_admin?
      @tours = Tour.all
    elsif current_user.is_driver?
      company = current_user.company
      @tours = Tour.where(company_id: company.id)
    elsif current_user.is_planer?
      company = current_user.company
      @tours = Tour.where(company_id: company.id)
    else
      @tours = []
    end
    
  end

  def edit
    #FIXME pause, start, done funktionen einfügen
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
    # Alle OrderTours von @tour löschen
    order_tours = @tour.order_tours
    order_tours.each do |order_tour|
      order_tour.destroy
    end
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
