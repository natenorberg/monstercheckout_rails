require 'rails_helper'

RSpec.describe 'shared/user_reservation', :type => :view do
  before(:each) do
    @reservation = FactoryGirl.create(:reservation)
    @test_user = stub_model(User)
    @test_user.stub(:is_admin?).and_return false
    view.stub(:current_user).and_return @test_user
    view.stub(:status_text).and_return 'Status text'
  end

  it 'renders a list of reservations' do
    render partial: 'shared/user_reservation', locals: { reservation: @reservation, show_approve_deny_buttons: false }

    assert_select '.reservation-icon>img.gravatar'

    assert_select '.reservation-info' do
      
      assert_select 'span.reservation-header>a', :text => @reservation.user.name
      assert_select 'span.reservation-subheader>a', :text => @reservation.project
      assert_select 'span.reservation-subheader', :text => /Status text/
      assert_select 'span.reservation-time', :text => "#{@reservation.out_time.strftime(ReservationsHelper::SHORT_DATETIME_FORMAT)} to #{@reservation.in_time.strftime(ReservationsHelper::SHORT_DATETIME_FORMAT)}"
    end
  end

  describe 'approve/deny buttons' do
    describe 'when user is admin' do
      before do 
        @test_user.stub(:is_admin?).and_return true
        @reservation.stub(:requested?).and_return true
      end

      it 'should render approve/deny buttons' do
        render partial: 'shared/user_reservation', locals: { reservation: @reservation, show_approve_deny_buttons: true }

        assert_select 'a.btn.btn-large.btn-success[href=?]', approve_reservation_path(@reservation), text: 'Approve', count: 1
        assert_select 'a.btn.btn-large.btn-danger[href=?]', deny_reservation_path(@reservation), text: 'Deny', count: 1
      end
    end

    describe 'when user is not admin' do
      before { @test_user.stub(:is_admin?).and_return false }

      it 'should not render approve/deny buttons' do
        render partial: 'shared/user_reservation', locals: { reservation: @reservation, show_approve_deny_buttons: true }

        assert_select 'a.btn.btn-large.btn-success[href=?]', approve_reservation_path(@reservation), text: 'Approve', count: 0
        assert_select 'a.btn.btn-large.btn-danger[href=?]', deny_reservation_path(@reservation), text: 'Deny', count: 0
      end
    end
  end
end
