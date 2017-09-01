class RestrictionsController < ApplicationController
  before_action :set_restriction, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if current_user && current_user.is_admin?
      @restrictions = Restriction.all
    end
  end

  def show
    if current_user && current_user.is_admin?
      @restriction
    end
  end

  def new
    if current_user && current_user.is_admin?
      @restriction = Restriction.new
    end
  end

  def edit
    # FIXME
  end

  def create
    @restriction = Restriction.new(restriction_params)
    if @restriction.save
      flash[:success] = t('.success', restriction_id: @restriction.id)
    respond_with(@restriction)
      else
      flash[:alert] = t('.failure')
      render 'new'
    end
  end

  def update
    if @restriction.update(restriction_params)
      flash[:success] = t('.success', restriction_id: @restriction.id)
    respond_with(@restriction)
      else
      flash[:alert] = t('.failure', restriction_id: @restriction.id)
      render("edit")
    end
  end

  def destroy
    if @restriction.destroy
       flash[:success] = t('.success', restriction_id: @restriction.id)
       respond_with(@restriction)
      else
      flash[:alert] = t('.failure', restriction_id: @restriction.id)
      respond_with(@restriction)
    end
  end

  private
    def set_restriction
      @restriction = Restriction.find(params[:id])
    end

    def restriction_params
      params.require(:restriction).permit(:company_id, :user_id, :problem, :dynamic, :multi_vehicle, :time_window, :capacity_restriction, :priorities, :work_time)
    end
end
