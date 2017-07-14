FactoryGirl.define do
  factory :active_driver, class: Driver do
    name Faker::Name.name
    working_time 480
    activ true
  end

  factory :inactive_driver, parent: :active_driver do
    activ false
  end
end
