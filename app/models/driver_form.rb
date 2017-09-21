class DriverForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor(
    :user_id, :name, :work_start_time, :work_end_time, :active, :working_time, :id, :email, :company_id, :password, :last_sign_in_at, :created_at, :username, :role
  )

    def self.model_name
    Driver.model_name
  end


  def register
    if valid?
      # Do something interesting here
      # - create user
      # - send notifications
      # - log events, etc.
     @driver = Driver.new()
     @user = User.new()
     @user.username = username
     @user.role = "driver"
     @user.password = password
     @user.email = email
     @user.company_id = company_id
     @driver.name = name
     @driver.active = active
     @driver.working_time = working_time
      @user.save!
      @driver.user_id = @user.id
      @driver.save!
    end
  end

end