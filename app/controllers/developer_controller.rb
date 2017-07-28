class DeveloperController < ApplicationController

  def index
    if current_user
      if current_user.is_admin?

      end
    end
  end

  def reset_database
    if current_user
      if current_user.is_admin?
        Order.destroy_all
        Tour.destroy_all
        CsvImport.new('').import_delivery_orders('My Company')
      end
    end
    redirect_to action: "index"
  end

end
