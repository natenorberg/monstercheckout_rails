require 'rails_helper'

RSpec.describe 'monitor/dashboard', :type => :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    assign(:checkouts, [ FactoryGirl.create(:approved_reservation), FactoryGirl.create(:approved_reservation)])
    assign(:checkins, [ FactoryGirl.create(:checkout), FactoryGirl.create(:checkout) ])

    mock_user = stub_model(User)
    mock_user.stub(:monitor_access?).and_return true
    view.stub(:current_user).and_return mock_user
  end

  it 'renders the index widgets' do
    render

    expect(rendered).to render_template(:partial => 'shared/_user_reservation_list', locals: { title: 'Ready to check out' })
    expect(rendered).to render_template(:partial => 'shared/_user_reservation_list', locals: { title: 'Ready to check in' })
  end
end
