require 'rails_helper'

RSpec.describe 'reservations/edit', :type => :view do
  before(:each) do
    @equipment = [FactoryGirl.create(:equipment), FactoryGirl.create(:equipment)]
    @equipment.stub(:where).and_return(@equipment)
    @categories = [FactoryGirl.create(:category)]
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
    assign(:equipment, @equipment)
  end

  it 'renders the edit reservation form' do
    render

    assert_select 'form[action=?][method=?]', reservation_path(@reservation), 'post' do

      assert_select 'input#reservation_project[name=?]', 'reservation[project]'

      assert_select 'input#reservation_out_time[name=?]', 'reservation[out_time]'

      assert_select 'input#reservation_in_time[name=?]', 'reservation[in_time]'

      assert_select 'ul.equipment-list' do

        assert_select 'li>span.equipment-choice-label', @equipment.first.name

        assert_select 'li>input[name=?][value=?]', 'reservation[equipment_ids][]', @equipment.first.id
      end

      assert_select 'input[name=commit][value=Update Reservation]'

    end

    verify_breadcrumbs ['Reservations', 'Project', 'Edit']
  end
end
