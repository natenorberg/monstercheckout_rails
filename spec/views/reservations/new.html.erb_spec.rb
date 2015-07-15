require 'rails_helper'

RSpec.describe 'reservations/new', :type => :view do
  before(:each) do
    @equipment = [FactoryGirl.create(:equipment), FactoryGirl.create(:equipment)]
    @equipment.stub(:where).and_return(@equipment)
    @categories = [FactoryGirl.create(:category)]
    @out_time = 1.days.ago
    @in_time = 1.days.from_now
    @user = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(@user)
    @reservation = assign(:reservation, Reservation.new(
      :user_id => @user.id,
      :project => 'Project',
      :out_time => @out_time,
      :in_time => @in_time,
      :is_approved => false,
    ))
    assign(:equipment, @equipment)
  end

  describe 'when user has no allowed equipment' do
    before do
      @equipment = []
      assign(:equipment, @equipment)
    end

    it 'renders a message that there is no equipment' do
      render
      assert_select '#equipment_list>h2', text: 'You have no approved equipment. Please contact your administrator.'
    end
  end

  it 'renders new reservation form' do
    render

    assert_select 'form[action=?][method=?]', reservations_path, 'post' do

      assert_select 'input#reservation_project[name=?]', 'reservation[project]'

      assert_select 'input#reservation_out_time[name=?]', 'reservation[out_time]'

      assert_select 'input#reservation_in_time[name=?]', 'reservation[in_time]'

      assert_select 'ul.equipment-list' do

        assert_select 'li>span.equipment-choice-label', @equipment.first.name

        assert_select 'li>input[name=?][value=?]', 'reservation[equipment_ids][]', @equipment.first.id
      end

      assert_select 'input[name=commit][value=Create Reservation]'
    end
  end

  it 'renders breadcrumbs' do
    render

    verify_breadcrumbs ['Reservations', 'New']
  end
end
