FactoryBot.define do
  factory :user do
    age 45
    dependents 2
    income 1000
    marital_status 'married'
    risk_questions [0, 1, 0]
    house_attributes { attributes_for(:house) }
    vehicle_attributes { attributes_for(:vehicle) }
  end
end
