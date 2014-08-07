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

  factory :reservation do
    user
    project 'Record all the stuff'
    out_time 1.days.ago
    in_time 2.days.from_now

    factory :checkout do
      checked_out_time 1.days.ago
      check_out_comments 'Lookin good'

      factory :checkin do
        checked_in_time Time.now
        check_in_comments 'Still lookin good'
      end
    end
  end

  factory :reservation_equipment do
    reservation
    equipment
    quantity 2
  end
end