FactoryGirl.define do
  factory :driver do
    name Faker::Name.name
    working_time 480
    activ true
  end
end
