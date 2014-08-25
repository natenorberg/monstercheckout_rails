require 'rails_helper'

RSpec.describe 'shared/icon_reservation', :type => :view do
  before(:each) do
    @reservation = FactoryGirl.create(:reservation)
    view.stub(:status_text).and_return 'status text'
  end

  it 'renders a list of reservations' do
    render partial: 'shared/icon_reservation', locals: { reservation: @reservation }

    assert_select '.reservation-icon>h2>i.fa.fa-calendar.fa-2x'

    assert_select '.reservation-info' do
      
      assert_select 'span.reservation-header>a', :text => @reservation.project
      assert_select "span.reservation-subheader.status_text_#{@reservation.id}", :text => 'status text'
      assert_select 'span.reservation-time', :text => "#{@reservation.out_time.strftime(ReservationsHelper::SHORT_DATETIME_FORMAT)} to #{@reservation.in_time.strftime(ReservationsHelper::SHORT_DATETIME_FORMAT)}"
    end
  end
end
