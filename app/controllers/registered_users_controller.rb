class RegisteredUsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if current_user && current_user.is_admin? && current_user.company_id?
      @users = User.where(company_id: current_user.company.id)
    end
    if current_user && current_user.is_superadmin? && current_user.company_id?
      @users = User.all
    end
  end

  def show
    if current_user && (current_user.is_admin? || (current_user.is_superadmin? && current_user.company_id?))
      if @user.company_id == current_user.company_id
        @user
      end
    end
  end

  def new
    if current_user && (current_user.is_admin? || (current_user.is_superadmin? && current_user.company_id?))
      @user = User.new
    end
  end

  def edit
    # FIXME
  end

  def create
    @user = User.new(user_params)
    @user.company_id = current_user.company_id
    if @user.save
      flash[:success] = t('.success', user_id: @user.id)
    redirect_to(registered_user_path(@user))
      else
        flash[:alert] = t('.failure')
        render 'new'
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t('.success', user_id: @user.id)
      redirect_to(registered_user_path(@user))
    else
      flash[:alert] = t('.failure', user_id: @user.id)
      render("edit")
    end
  end

  def destroy
    if current_user && (current_user.is_admin? || current_user.is_superadmin?)
      if @user.destroy
        flash[:success] = t('.success', user_id: @user.id)
        redirect_to(registered_user_path)
        else
        flash[:alert] = t('.failure', user_id: @user.id)
        redirect_to(registered_user_path)
      end
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:id, :email, :company_id, :password, :last_sign_in_at, :created_at, :username, :role)
    end
end
