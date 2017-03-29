class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if (current_user.is_admin? || current_user.is_planer?) && !current_user.company.nil?
      company = current_user.company
      @orders = Order.where(company_id: company.id)
    else
      @orders = []
    end
  end

  def show
    if current_user
      if current_user.is_admin?
        @order
      elsif current_user.is_planer?
        if @driver.company_id == current_user.company_id
          @driver
        end
      end
    end
  end

  def new
    if current_user
      if current_user.is_admin? || current_user.is_planer?
        @order = Order.new
      end
    end
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    @order.user_id = current_user.id # automatisches setzen der user_id
    @order.save
    respond_with(@order)
  end

  def update
    @order.update(order_params)
    respond_with(@order)
  end

  def destroy
    @order.destroy
    respond_with(@order)
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:user_id, :address, :customer_id, :company_id, :pickup_location, :delivery_location, :capacity, :start_time, :end_time, :comment, :duration_pickup, :duration_delivery, :activ)
    end
end
