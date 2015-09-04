class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :costumer
  belongs_to :company
end
