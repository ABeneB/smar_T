class CostumersController < ApplicationController
  before_action :set_costumer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    # Nur Daten die Zur Rolle passen anzeigen
    if current_user 
      if current_user.is_admin? || current_user.is_planer?
        @costumers = Costumer.where(company_id: current_user.company_id)
      else
        @costumers = []
      end
    end
  end

  def show
    if current_user
      if current_user.is_admin? 
        @costumer
      elsif current_user.is_planer?
        if @costumer.company_id == current_user.company_id
          @costumer
        end
      end
    end
  end

  def new
    # Nur Daten die Zur Rolle passen anzeigen
    if current_user
      if current_user.is_admin? || current_user.is_planer?
        @costumer = Costumer.new
      end
    end
  end

  def edit
    # FIXME
  end

  def create
    @costumer = Costumer.new(costumer_params)
    @costumer.user_id = current_user.id # automatisches setzen der user_id
    @costumer.company_id = current_user.company.id
    @costumer.save
    if @costumer.save 
      redirect_to costumers_path, notice: "saved"
    else
      render 'new'
    end
  end

  def update
    @costumer.update(costumer_params)
    respond_with(@costumer)
  end

  def destroy
    @costumer.destroy
    respond_with(@costumer)
  end

  private
    def set_costumer
      @costumer = Costumer.find(params[:id])
    end

    def costumer_params
      params.require(:costumer).permit(:user_id, :name, :company_id, :address, :telefon, :priority)
    end
end
