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
        # assign company to admin user
        current_user.company = Company.first
        current_user.save

        # destroy orders + tours and import orders from csv
        OrderTour.destroy_all
        Order.destroy_all
        Tour.destroy_all
        CsvImport.new('').import_delivery_orders()

        # recreate drivers and vehicles
        Driver.destroy_all
        Vehicle.destroy_all

        driver = Driver.new({'name' => 'Fritz', 'working_time' => '480', 'user_id' => current_user.id, 'activ' => true})
        driver.save
        Vehicle.new({'position' => current_user.company.address, 'capacity' => '100', 'driver_id' => driver.id}).save

        driver = Driver.new({'name' => 'Sabine', 'working_time' => '480', 'user_id' => current_user.id, 'activ' => true})
        driver.save
        Vehicle.new({'position' => current_user.company.address, 'capacity' => '100', 'driver_id' => driver.id}).save

        driver = Driver.new({'name' => 'Hans-Georg', 'working_time' => '480', 'user_id' => current_user.id, 'activ' => true})
        driver.save
        Vehicle.new({'position' => current_user.company.address, 'capacity' => '100', 'driver_id' => driver.id}).save

        # run tour generation
        Algorithm::TourGeneration.generate_tours(Company.first)
      end
    end
    redirect_to action: "index"
  end

end
