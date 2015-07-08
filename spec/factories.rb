FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person#{n}@example.com"}
    password 'password1'
    password_confirmation 'password1'

    factory :admin do
      is_admin true
      notify_on_approval_needed true
    end

    factory :monitor do
      is_monitor true
    end
  end

  factory :permission do
    sequence(:name) { |n| "Permission #{n}"}
    description 'A permission used for testing'
  end

  factory :equipment do
    sequence(:name) { |n| "Mic #{n}" }
    brand 'Test Brand'
    category
    quantity 2
    condition 'Good'
    description 'A sample mic used for testing MONSTER Checkout'
  end

  factory 'sub_item' do
    sequence(:name) { |n| "Item #{n}" }
    brand 'Test Brand'
    kit_id 1
    description 'A test item in a kit'
    is_optional false
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
      association :checked_out_by, :factory => :monitor
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

  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description 'Equipment used for testing the app'
  end
end
