class CostumersController < ApplicationController
  before_action :set_costumer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    
    if current_user.is_admin?
      @costumers = Costumer.all
    elsif current_user.is_driver?
      @tours = []
    elsif current_user.is_planer?
      company = current_user.company
      @tours = Costumer.where(company_id: company.id)
    else
      @tours = []
    end
    
  end

  def show
    # FIXME - hat er zurgriff?
    respond_with(@costumer)
  end

  def new
    @costumer = Costumer.new
    respond_with(@costumer)
  end

  def edit
  end

  def create
    @costumer = Costumer.new(costumer_params)
    # @costumer.user_id = current_user.id # automatisches setzen der user_id
    respond_with(@costumer)
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
