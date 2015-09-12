class WelcomeController < ApplicationController
  def index
    if current_user && current_user.is_driver?
      @tour =  Tour.where(user_id: current_user.id).take
    end
  end
end
