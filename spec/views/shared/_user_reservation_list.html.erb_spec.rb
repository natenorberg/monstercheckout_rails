require 'rails_helper'

RSpec.describe 'shared/_user_reservation_list', :type => :view do
  before(:each) do
    @title = 'Test Reservations'
    @empty_text = 'Nothing to see here'
    @reservations = [ FactoryGirl.create(:reservation), FactoryGirl.create(:reservation)]
    @test_user = stub_model(User)
    @test_user.stub(:is_admin).and_return false
    view.stub(:current_user).and_return @test_user
  end

  it 'renders a list of reservations' do
    render partial: 'shared/user_reservation_list', locals: { reservations: @reservations, title: @title, show_approve_deny_buttons: false }

    assert_select '.panel-heading>h3.panel-title', text: @title

    expect(rendered).to render_template(:partial => 'shared/_user_reservation')
  end

  it 'renders message when there are no reservations' do
    render partial: 'shared/user_reservation_list', locals: { reservations: [], title: @title, show_approve_deny_buttons: false }

    assert_select '.panel-heading>h3.panel-title', text: @title

    assert_select '.panel-body>em', text: 'No reservations'
  end

  it 'renders custom message when there are no reservations' do
    render partial: 'shared/user_reservation_list', locals: { reservations: [], title: @title, empty_text: @empty_text, show_approve_deny_buttons: false }

    assert_select '.panel-heading>h3.panel-title', text: @title

    assert_select '.panel-body>em', text: @empty_text
  end

  describe 'approve/deny buttons' do
    describe 'when user is admin' do
      before do 
        @reservations.each do |reservation|
          reservation.stub(:requested?).and_return true
        end

        @test_user.stub(:is_admin?).and_return true
      end

      it 'should render approve/deny buttons' do
        render partial: 'shared/user_reservation_list', locals: { reservations: @reservations, title: @title, show_approve_deny_buttons: true }

        assert_select 'a.btn.btn-large.btn-success', text: 'Approve', count: 2
        assert_select 'a.btn.btn-large.btn-danger', text: 'Deny', count: 2
      end
    end

    describe 'when user is not admin' do
      before { @test_user.stub(:is_admin?).and_return false }

      it 'should not render approve/deny buttons' do
        render partial: 'shared/user_reservation_list', locals: { reservations: @reservations, title: @title, show_approve_deny_buttons: true }

        assert_select 'a.btn.btn-large.btn-success', text: 'Approve', count: 0
        assert_select 'a.btn.btn-large.btn-danger', text: 'Deny', count: 0
      end
    end
  end

  describe 'checkout/checkin buttons' do
    describe 'when user is monitor' do
      before do

        @test_user.stub(:monitor_access?).and_return true
      end

      it 'should render checkout button' do 
        @reservations.each do |reservation|
          reservation.stub(:approved?).and_return true
        end
        render partial: 'shared/user_reservation_list', locals: { reservations: @reservations, title: @title, show_approve_deny_buttons: true }

        assert_select 'a.btn.btn-large.btn-primary', text: 'Check Out', count: 2
      end

      it 'should render checkin button' do 
        @reservations.each do |reservation|
          reservation.stub(:can_checkin?).and_return true
        end
        render partial: 'shared/user_reservation_list', locals: { reservations: @reservations, title: @title, show_approve_deny_buttons: true }

        assert_select 'a.btn.btn-large.btn-primary', text: 'Check In', count: 2
      end
    end

    describe 'when user is not monitor' do
      before { @test_user.stub(:monitor_access?).and_return false }

      it 'should not render checkout/checkin buttons' do
        render partial: 'shared/user_reservation_list', locals: { reservations: @reservations, title: @title, show_approve_deny_buttons: true }

        assert_select 'a.btn.btn-large.btn-primary', text: 'Check Out', count: 0
        assert_select 'a.btn.btn-large.btn-primary', text: 'Check In', count: 0
      end
    end
  end
end