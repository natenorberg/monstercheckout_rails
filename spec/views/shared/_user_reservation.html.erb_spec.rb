require 'rails_helper'

RSpec.describe 'shared/user_reservation', :type => :view do
  before(:each) do
    @reservation = FactoryGirl.create(:reservation)
  end

  it 'renders a list of reservations' do
    render partial: 'shared/user_reservation', locals: { reservation: @reservation }

    assert_select '.reservation-icon>img.gravatar'

    assert_select '.reservation-info' do
      
      assert_select 'span.reservation-header>a', :text => @reservation.user.name
      assert_select 'span.reservation-subheader>a', :text => @reservation.project
      assert_select 'span.reservation-time', :text => "#{@reservation.out_time.strftime(ReservationsHelper::SHORT_DATETIME_FORMAT)} to #{@reservation.in_time.strftime(ReservationsHelper::SHORT_DATETIME_FORMAT)}"
    end
  end
end
