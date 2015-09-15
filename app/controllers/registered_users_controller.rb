class RegisteredUsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @users = User.all
    respond_with(@users)
  end

  def show
    respond_with(@user)
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.save
    redirect_to(registered_user_path(@user))
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to(registered_user_path(@user))
    else
      render("edit")
    end
  end

  def destroy
    @user.destroy
    redirect_to(registered_user_path)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:id, :email, :company_id, :password, :last_sign_in_at, :created_at, :username, :role)
    end
end
