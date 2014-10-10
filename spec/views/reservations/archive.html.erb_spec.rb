require 'rails_helper'

RSpec.describe 'reservations/archive', :type => :view do
  before(:each) do
    assign(:reservations, [
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

  it 'renders the user_reservation partial' do
    render

    expect(rendered).to render_template(:partial => 'shared/_user_reservation')
  end
end