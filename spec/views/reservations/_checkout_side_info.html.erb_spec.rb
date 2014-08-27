require 'rails_helper'

RSpec.describe 'reservations/_checkout_side_info', :type => :view do
  before(:each) do
    @out_time = 1.days.ago
    @in_time = 1.days.from_now
    @user = FactoryGirl.create(:user)    
    @reservation = assign(:reservation, Reservation.create!(
      :user_id => @user.id,
      :project => 'Project',
      :out_time => @out_time,
      :in_time => @in_time,
      :is_approved => false,
    ))
  end

  it 'renders reservation info' do
    render partial: 'reservations/checkout_side_info'

    assert_select '.checkout-side' do
      
      assert_select '.checkout-side-info' do

        assert_select 'h2.checkout-username', :text => @user.name

        assert_select 'h3.checkout-project', :text => /Project/
      end

      assert_select 'h4.checkout-info', :text => "Reservation Time: #{@reservation.out_time.strftime(ReservationsHelper::SHORT_DATETIME_FORMAT)}"

      assert_select 'h4.checkout-info', :text => "Due: #{@reservation.in_time.strftime(ReservationsHelper::SHORT_DATETIME_FORMAT)}"
    end
  end
end