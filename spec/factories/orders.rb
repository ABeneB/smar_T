FactoryGirl.define do
  factory :delivery_order, class: Order do
    delivery_location { Faker::Address.street_name + " " + Faker::Address.building_number + " " + Faker::Address.postcode + " "  + Faker::Address.city }
    capacity 10
    start_time { DateTime.now + 10.minutes }
    end_time { DateTime.now + 2.hours }
    duration_delivery 20
    activ true
  end
end
