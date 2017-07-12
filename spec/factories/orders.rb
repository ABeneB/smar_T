FactoryGirl.define do
  factory :delivery_order, class: Order do
    pickup_location Faker::Address.street_name + " " + Faker::Address.building_number + " " + Faker::Address.postcode + " "  + Faker::Address.city
    capacity 3
    duration_delivery 20
    activ true
  end
end
