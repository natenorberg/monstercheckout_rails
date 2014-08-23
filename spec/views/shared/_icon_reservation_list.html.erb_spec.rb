require 'rails_helper'

RSpec.describe 'shared/_icon_reservation_list', :type => :view do
  before(:each) do
    @title = 'Test Reservations'
    @reservations = [ FactoryGirl.create(:reservation), FactoryGirl.create(:reservation)]
  end

  it 'renders a list of reservations' do
    render partial: 'shared/icon_reservation_list', locals: { reservations: @reservations, title: @title }

    assert_select '.panel-heading>h3.panel-title', text: @title

    expect(rendered).to render_template(:partial => 'shared/_icon_reservation')

    assert_select 'a.btn.btn-large.btn-primary', :text => 'New Reservation'
  end

  it 'renders message when there are no reservations' do
    render partial: 'shared/icon_reservation_list', locals: { reservations: [], title: @title }

    assert_select '.panel-heading>h3.panel-title', text: @title

    assert_select '.panel-body>em', text: 'You have no reservations'

    assert_select 'a.btn.btn-large.btn-primary', :text => 'New Reservation'
  end
end