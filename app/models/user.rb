class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  USER_ROLE = "user"
  ADMIN_ROLE = "admin"
  DRIVER_ROLE = "driver"
  PLANER_ROLE = "planer"
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login
  
  #->Prelang (user_login:devise/username_login_support)
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.downcase}]).first
    else
      where(conditions).first
    end
  end


  devise authentication_keys: [:login]
  
  before_create do
    self.role = USER_ROLE
  end
  
  def is_admin?
    role == ADMIN_ROLE
  end
  
  def is_user?
    role == USER_ROLE
  end
  
  def is_driver?
    role == DRIVER_ROLE
  end
  
  def is_planer?
    role == PLANER_ROLE
  end
  
end
