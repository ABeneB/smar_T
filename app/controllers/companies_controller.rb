class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    # Nur Daten die Zur Rolle passen anzeigen
    if current_user && current_user.is_admin?
        @companies = Company.all
    end
  end

  def show
    if current_user && current_user.is_admin?
        @company
    end
  end

  def new
    if current_user && current_user.is_admin?
      @company = Company.new
    end
  end

  def edit
    # FIXME
  end

  def create
      @company = Company.new(company_params)
      @company.save
  end

  def update
      @company.update(company_params)
  end

  def destroy
      @company.destroy
  end

  private
    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:user_id, :name, :address, :telefon)
    end
end
