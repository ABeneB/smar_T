class DepotsController < ApplicationController
  before_action :set_depot, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    # Nur Daten die Zur Rolle passen anzeigen
    if current_user 
      if current_user.is_admin?
        @depots = Depot.all
      elsif current_user.is_planer?
        company = current_user.company
        @depots = Depot.where(company_id: company.id)
      else
        @depots = []
      end
    end
  end

  def show
    if current_user
      if current_user.is_admin?
        @depot
      elsif current_user.is_planer?
        if @depot.company_id == current_user.company_id
          @depot
        end
      end
    end
  end

  def new
    if current_user
      if current_user.is_admin? || current_user.is_planer?
        @depot = Depot.new
      end
    end
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
      params.require(:depot).permit(:user_id, :name, :company_id, :address, :duration)
    end
end
