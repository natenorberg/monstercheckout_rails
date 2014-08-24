require 'rails_helper'

RSpec.describe 'shared/_user_reservation_list', :type => :view do
  before(:each) do
    @title = 'Test Reservations'
    @empty_text = 'Nothing to see here'
    @reservations = [ FactoryGirl.create(:reservation), FactoryGirl.create(:reservation)]
    mock_user = stub_model(User)
    mock_user.stub(:is_admin).and_return false
    view.stub(:current_user).and_return mock_user
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
end