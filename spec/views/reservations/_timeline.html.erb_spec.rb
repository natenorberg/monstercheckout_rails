require 'rails_helper'

RSpec.describe 'reservations/_timeline', :type => :view do
  before(:each) do
    @out_time = 1.days.ago
    @in_time = 1.days.from_now
    @user = FactoryGirl.create(:user)    
    @reservation = assign(:reservation, Reservation.create!(
      :user_id => @user.id,
      :project => 'Project',
      :out_time => @out_time,
      :in_time => @in_time,
      :is_approved => false,
    ))  
    view.stub(:auto_shrink_date).with(@reservation.created_at).and_return 'Created Date'
  end

  it 'renders submitted date' do
    render partial: 'reservations/timeline'

    assert_select 'li.list-group-item>strong.status-text-requested'
    assert_select 'li.list-group-item', text: /Created Date/
  end

  describe 'updated record' do
    before(:each) do
      @reservation.updated_at = Time.now
      @reservation.status = :requested
      view.stub(:auto_shrink_date).with(@reservation.updated_at).and_return 'Updated Date'
    end

    it 'renders updated date' do
      render partial: 'reservations/timeline'

      assert_select 'li.list-group-item>strong.status-text-updated'
      assert_select 'li.list-group-item', text: /Updated Date/
    end
  end

  describe 'approved record' do
    before(:each) do
      @reservation.is_approved = true
      @reservation.admin_response_time
      view.stub(:auto_shrink_date).with(@reservation.admin_response_time).and_return 'Approved Date'
    end

    it 'renders approved date' do
      render partial: 'reservations/timeline'

      assert_select 'li.list-group-item>strong.status-text-approved'
      assert_select 'li.list-group-item', text: /Approved Date/
    end
  end

  describe 'denied record' do
    before(:each) do
      @reservation.is_denied = true
      @reservation.admin_response_time
      view.stub(:auto_shrink_date).with(@reservation.admin_response_time).and_return 'Denied Date'
    end

    it 'renders denied date' do
      render partial: 'reservations/timeline'

      assert_select 'li.list-group-item>strong.status-text-denied'
      assert_select 'li.list-group-item', text: /Denied Date/
    end
  end
end