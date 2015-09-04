class CostumersController < ApplicationController
  before_action :set_costumer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @costumers = Costumer.all
    respond_with(@costumers)
  end

  def show
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
    @costumer.save
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
      params.require(:costumer).permit(:user_id, :company_id, :address, :telefon, :priority)
    end
end
