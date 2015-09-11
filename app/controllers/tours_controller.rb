class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    # FIXME ünbergabe alle OrderTours der Tour
    if current_user.is_admin?
      @tours = Tour.all
      respond_with(@tours)
    elsif current_user.is_driver?
      company = Company.find(user_id: current_user.id)
      @tours = Tour.where(company_id: company.id)
      respond_with(@tours)
    elsif current_user.is_planer?
      company = Company.find(user_id: current_user.id)
      @tours = Tour.where(company_id: company.id)
      respond_with(@tours)
    else
      respond_with([])# nichts
    end
  end

  def show
    respond_with(@tour)
  end

  def new
    # Orders, Drivers und Company filter/suchen
    user = User.find(current_user.id)
    
    #FIXME - er filltert nicht richtig
    #drivers = Driver.where(user_id: user.id)
    #activ_drivers = []
    #drivers.each do |driver|
    #  if driver.activ
    #    activ_drivers.push(driver)
    #  end
    #end
    
    activ_drivers = Driver.all
    
    #orders = Order.where(user_id: user.id)
    #activ_orders = []
    #orders.each do |order|
    #  if order.activ
    #    activ_orders.push(order)
    #  end
    #end
    activ_orders = Order.all
    
    company = Company.find(user.id)
    
    # Tourenplanungsalgorithmus starten
    g = Generate.new
    g.drivers = activ_drivers
    g.orders = activ_orders
    g.company = company
    g.user = current_user
    
    # Generate erzeugt und speichert die neuen Touren, OrderTour-Objekte
    g.generate_tours
    
    #Ausgabe nach Rolle filtern
    if current_user.is_admin?
      @tours = Tour.all
      respond_with(@tours)
    elsif current_user.is_driver?
      company = Company.find(user_id: current_user.id)
      @tours = Tour.where(company_id: company.id)
      respond_with(@tours)
    elsif current_user.is_planer?
      company = Company.find(user_id: current_user.id)
      @tours = Tour.where(company_id: company.id)
      respond_with(@tours)
    else
      respond_with([])# nichts
    end
    
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
