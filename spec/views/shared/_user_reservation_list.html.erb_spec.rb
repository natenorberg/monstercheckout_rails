require 'rails_helper'

RSpec.describe 'shared/_user_reservation_list', :type => :view do
  before(:each) do
    @title = 'Test Reservations'
    @empty_text = 'Nothing to see here'
    @reservations = [ FactoryGirl.create(:reservation), FactoryGirl.create(:reservation)]
  end

  it 'renders a list of reservations' do
    render partial: 'shared/user_reservation_list', locals: { reservations: @reservations, title: @title }

    assert_select '.panel-heading>h3.panel-title', text: @title

    expect(rendered).to render_template(:partial => 'shared/_user_reservation')
  end

  it 'renders message when there are no reservations' do
    render partial: 'shared/user_reservation_list', locals: { reservations: [], title: @title }

    assert_select '.panel-heading>h3.panel-title', text: @title

    assert_select '.panel-body>em', text: 'No reservations'
  end

  it 'renders custom message when there are no reservations' do
    render partial: 'shared/user_reservation_list', locals: { reservations: [], title: @title, empty_text: @empty_text }

    assert_select '.panel-heading>h3.panel-title', text: @title

    assert_select '.panel-body>em', text: @empty_text
  end
end