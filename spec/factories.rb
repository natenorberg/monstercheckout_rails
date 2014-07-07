FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person#{n}@example.com"}
    password 'password1'
    password_confirmation 'password1'
  end
end