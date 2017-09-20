class DriverFormsController < ApplicationController
  respond_to :html

  def new
    @driver_form = DriverForm.new
  end

  def create
    @driver_form = DriverForm.new(driver_form_params)
    @driver_form.company_id = current_user.company_id
    @driver_form.register

    #respond_with @registration, location: some_success_path
   redirect_to drivers_path
  end

  private

  def driver_form_params
    params.require(:driver_form).permit(:user_id, :name, :work_start_time, :work_end_time, :active, :working_time, :id, :email, :company_id, :password, :last_sign_in_at, :created_at, :username, :role)
  end
end
