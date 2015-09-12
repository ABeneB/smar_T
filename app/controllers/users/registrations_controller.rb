class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper

  def create
    super
  end

  def new
    redirect_to(root_path, alert:"No signup!")
  end

  def edit
    super
  end
end
