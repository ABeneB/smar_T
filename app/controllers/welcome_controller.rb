class WelcomeController < ApplicationController
  def index
    if current_user && current_user.is_driver?
      @tour =  Tour.where(driver_id: current_user.id).take
    elsif current_user && current_user.is_planer?
      if current_user.company
        @drivers = current_user.company.driver
      end
    end
  end
end
