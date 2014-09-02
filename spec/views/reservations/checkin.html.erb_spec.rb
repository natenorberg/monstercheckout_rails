require 'rails_helper'

RSpec.describe 'reservations/checkin', :type => :view do
  before(:each) do
    @equipment = FactoryGirl.create(:equipment)
    @out_time = 1.days.ago
    @in_time = 1.days.from_now
    @user = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(@user)
    @reservation = assign(:reservation, Reservation.create!(
      :user_id => @user.id,
      :project => 'Project',
      :out_time => @out_time,
      :in_time => @in_time,
      :is_approved => false,
    ))
  end

  it 'renders the checkout reservation form' do
    render

    expect(rendered).to render_template(:partial => '_checklist')

    assert_select 'form[action=?][method=?]', checkin_update_reservation_path(@reservation), 'post' do

      assert_select 'textarea#reservation_check_in_comments[name=?]', 'reservation[check_in_comments]'

      expect(rendered).to render_template(:partial => '_checkout_side_info')
    end
  end

  it 'renders breadcrumbs' do
    render

    verify_breadcrumbs ['Monitor', 'Project', 'Check In']
  end
end