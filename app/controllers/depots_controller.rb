class DepotsController < ApplicationController
  before_action :set_depot, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @depots = Depot.all
    respond_with(@depots)
  end

  def show
    respond_with(@depot)
  end

  def new
    @depot = Depot.new
    respond_with(@depot)
  end

  def edit
  end

  def create
    @depot = Depot.new(depot_params)
    @depot.save
    respond_with(@depot)
  end

  def update
    @depot.update(depot_params)
    respond_with(@depot)
  end

  def destroy
    @depot.destroy
    respond_with(@depot)
  end

  private
    def set_depot
      @depot = Depot.find(params[:id])
    end

    def depot_params
      params.require(:depot).permit(:user_id, :company_id, :address, :duration)
    end
end
