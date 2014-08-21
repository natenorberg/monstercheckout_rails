require 'rails_helper'

RSpec.describe 'reservations/show', :type => :view do
  before(:each) do
    @out_time = 1.days.ago
    @in_time = 1.days.from_now
    @user = FactoryGirl.create(:user)
    @equipment = [FactoryGirl.create(:equipment), FactoryGirl.create(:equipment)]
    @reservation = assign(:reservation, Reservation.create!(
      :user_id => @user.id,
      :project => 'Project',
      :out_time => @out_time,
      :in_time => @in_time,
      :is_approved => false,
    ))
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(@user.name)
    expect(rendered).to match(/Project/)
    expect(rendered).to match(@out_time.strftime('%A, %B %d, %Y, %I:%M %p'))
    expect(rendered).to match(@in_time.strftime('%A, %B %d, %Y, %I:%M %p'))
  end
end
