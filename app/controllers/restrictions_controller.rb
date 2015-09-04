class RestrictionsController < ApplicationController
  before_action :set_restriction, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @restrictions = Restriction.all
    respond_with(@restrictions)
  end

  def show
    respond_with(@restriction)
  end

  def new
    @restriction = Restriction.new
    respond_with(@restriction)
  end

  def edit
  end

  def create
    @restriction = Restriction.new(restriction_params)
    @restriction.save
    respond_with(@restriction)
  end

  def update
    @restriction.update(restriction_params)
    respond_with(@restriction)
  end

  def destroy
    @restriction.destroy
    respond_with(@restriction)
  end

  private
    def set_restriction
      @restriction = Restriction.find(params[:id])
    end

    def restriction_params
      params.require(:restriction).permit(:company_id, :user_id, :problem, :dynamic, :multi_vehicle, :time_window, :capacity_restriction, :priorities, :work_time)
    end
end
