class UserForm
  include ActiveModel::Model

  attr_accessor :user_id, :name, :work_start_time, :work_end_time, :active, :working_time, :id, :email, :company_id, :password, :last_sign_in_at, :created_at, :username, :role

  validates :username, :password, :email, presence: true
  validates :role, inclusion: { in: ["superadmin","admin", "planer", "driver", "user", "guest"],
    message: "%{value} is not a valid role." }, presence: true
  validates :working_time, :inclusion => { :in => 0..1440 }, :if => :driver_selected?

  def driver_selected?
     role ==  'driver'
  end
  
  def register
    if valid?
      # Do something interesting here
      # - create user
      # - send notifications
      # - log events, etc.

     if role == "driver"
      @driver = Driver.new()
      @user = User.new()
      @user.username = username
      @user.role = role
      @user.password = password
      @user.email = email
      @user.company_id = company_id
      @driver.name = username
      @driver.active = active
      @driver.working_time = working_time
      @user.save
      @driver.user_id = @user.id
      @driver.save
     else
      @user = User.new()
      @user.username = username
      @user.email = email
      @user.password = password
      @user.role = role
      @user.company_id = company_id
      @user.save
     end

    else
       false
    end
  end

end