class Order < ActiveRecord::Base
  belongs_to :customer

  # FIXME validation für address

end
