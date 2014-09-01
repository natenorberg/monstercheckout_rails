FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person#{n}@example.com"}
    password 'password1'
    password_confirmation 'password1'

    factory :admin do
      is_admin true
    end

    factory :monitor do
      is_monitor true
    end
  end

  factory :equipment do
    sequence(:name) { |n| "Mic #{n}" }
    brand 'Test Brand'
    quantity 2
    condition 'Good'
    description 'A sample mic used for testing MONSTER Checkout'
  end

  factory :reservation do
    user
    project 'Record all the stuff'
    out_time 1.days.ago
    in_time 2.days.from_now
    status 'requested'

    factory :approved_reservation do
      status 'approved'
      is_approved true
    end

    factory :checkout do
      checked_out_time 1.days.ago
      check_out_comments 'Lookin good'
      status 'out'

      factory :checkin do
        checked_in_time Time.now
        check_in_comments 'Still lookin good'
        status 'returned'
      end
    end
  end

  factory :reservation_equipment do
    reservation
    equipment
    quantity 2
  end

  factory :permission do
    sequence(:name) { |n| "Permission #{n}"}
    description 'A permission used for testing'
  end
end