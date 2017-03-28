class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if current_user
      if current_user.is_admin?
        @customers = Customer.all
      elsif current_user.is_planer?
        @customers = Customer.where(company_id: current_user.company_id)
      else
        @customers = []
      end
    end
  end

  def show
    if current_user
      if current_user.is_admin?
        @customer
      elsif current_user.is_planer?
        if @customer.company_id == current_user.company_id
          @customer
        end
      end
    end
  end

  def new
    if current_user
      if current_user.is_admin? || current_user.is_planer?
        @customer = Customer.new
      end
    end
  end

  def edit
    # FIXME
  end

  def create
    @customer = Customer.new(customer_params)
    if current_user.is_planer?
      @customer.user_id = current_user.id # automatisches setzen der user_id
      @customer.company_id = current_user.company.id
    end
    @customer.save
    if @customer.save
      redirect_to customers_path, notice: "saved"
    else
      render 'new'
    end
  end

  def update
    @customer.update(customer_params)
    respond_with(@customer)
  end

  def destroy
    @customer.destroy
    respond_with(@customer)
  end

  private
    def set_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:user_id, :name, :company_id, :address, :telefon, :priority)
    end
end
