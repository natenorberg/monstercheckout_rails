require 'rails_helper'

RSpec.describe 'reservations/admin_index', :type => :view do
  before(:each) do
    @user = FactoryGirl.create(:admin)
    reservations = [
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
    ]

    assign(:user_reservations, reservations)
    assign(:awaiting_approval, reservations)
    assign(:all_reservations, reservations)
  end

  it 'renders the index widgets' do
    render

    expect(rendered).to render_template(:partial => 'shared/_user_reservation_list', locals: { title: 'Awaiting Approval' })
    expect(rendered).to render_template(:partial => 'shared/_icon_reservation_list', locals: { title: 'Your Reservations' })
    expect(rendered).to render_template(:partial => 'shared/_user_reservation_list', locals: { title: 'All Reservations' })
  end
end
