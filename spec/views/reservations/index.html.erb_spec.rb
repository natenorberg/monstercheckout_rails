require 'rails_helper'

RSpec.describe 'reservations/index', :type => :view do
  before(:each) do
    assign(:user_reservations, [
      Reservation.create!(
        :project => 'Project',
        :user_id => FactoryGirl.create(:user).id,
        :out_time => 1.days.ago,
        :in_time => 1.days.from_now,
        :is_approved => false,
        :status => 'requested',
        :check_out_comments => 'MyTextOut',
        :check_in_comments => 'MyTextIn'
      ),
      Reservation.create!(
        :project => 'Project',
        :user_id => FactoryGirl.create(:user).id,
        :out_time => 1.days.ago,
        :in_time => 1.days.from_now,
        :is_approved => false,
        :status => 'requested',
        :check_out_comments => 'MyTextOut',
        :check_in_comments => 'MyTextIn'
      )
    ])
  end

  it 'renders a list of reservations' do
    render
    assert_select 'tr>td>.reservation-info>span.reservation-header', :text => 'Project'.to_s, :count => 2
    assert_select 'tr>td>.reservation-info>span.reservation-subheader', :text => 'Waiting for approval', :count => 2
  end
end
