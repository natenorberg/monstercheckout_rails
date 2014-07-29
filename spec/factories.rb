FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person#{n}@example.com"}
    password 'password1'
    password_confirmation 'password1'

    factory :admin do
      is_admin true
    end
  end

  factory :equipment do
    sequence(:name) { |n| "Mic #{n}" }
    brand 'Test Brand'
    quantity 1
    condition 'Good'
    description 'A sample mic used for testing MONSTER Checkout'
  end
end