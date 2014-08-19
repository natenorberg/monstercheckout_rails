require 'rails_helper'

RSpec.describe 'reservations/new', :type => :view do
  before(:each) do
    @out_time = 1.days.ago
    @in_time = 1.days.from_now
    @user = FactoryGirl.create(:user)
    @reservation = assign(:reservation, Reservation.new(
      :user_id => @user.id,
      :project => 'Project',
      :out_time => @out_time,
      :in_time => @in_time,
      :is_approved => false,
    ))
  end

  it 'renders new reservation form' do
    render

    assert_select 'form[action=?][method=?]', reservations_path, 'post' do

      assert_select 'input#reservation_project[name=?]', 'reservation[project]'
    end
  end
end
