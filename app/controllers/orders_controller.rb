class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if (current_user.is_admin? || current_user.is_planer?) && !current_user.company.nil?
      company = current_user.company
      @orders = company.orders
    else
      @orders = []
    end
  end

  def show
    if current_user
      if current_user.is_admin?
        @order
      elsif current_user.is_planer?
        if @driver.company.id == current_user.company_id
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
    if @order.save
      flash[:success] = t('.success', order_id: @order.id)
    respond_with(@order)
      else
       flash[:alert] = t('.failure')
    end
  end

  def update
    if @order.update(order_params)
      flash[:success] = t('.success', order_id: @order.id)
    respond_with(@order)
      else
      flash[:alert] = t('.failure', order_id: @order.id)
    end
  end

  def destroy
    if @order.destroy
      flash[:success] = t('.success', order_id: @order.id)
    respond_with(@order)
      else
      flash[:alert] = t('.failure', order_id: @order.id)
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:address, :customer_id, :pickup_location, :delivery_location, :capacity, :start_time, :end_time, :comment, :duration_pickup, :duration_delivery, :activ)
    end
end
