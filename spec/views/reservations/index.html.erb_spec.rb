require 'rails_helper'

RSpec.describe 'reservations/index', :type => :view do
  before(:each) do
    assign(:reservations, [
      Reservation.create!(
        :project => 'Project',
        :user_id => FactoryGirl.create(:user).id,
        :out_time => 1.days.ago,
        :in_time => 1.days.from_now,
        :is_approved => false,
        :check_out_comments => 'MyTextOut',
        :check_in_comments => 'MyTextIn'
      ),
      Reservation.create!(
        :project => 'Project',
        :user_id => FactoryGirl.create(:user).id,
        :out_time => 1.days.ago,
        :in_time => 1.days.from_now,
        :is_approved => false,
        :check_out_comments => 'MyTextOut',
        :check_in_comments => 'MyTextIn'
      )
    ])
  end

  it 'renders a list of reservations' do
    render
    assert_select 'tr>td', :text => 'Project'.to_s, :count => 2
    assert_select 'tr>td', :text => false.to_s, :count => 2
    assert_select 'tr>td', :text => 'MyTextOut'.to_s, :count => 2
    assert_select 'tr>td', :text => 'MyTextIn'.to_s, :count => 2
  end
end
