require 'rails_helper'

RSpec.describe 'static_pages/home.html.erb', :type => :view do

  before do
    @mock_user = stub_model(User)
    @mock_user.stub(:is_admin?).and_return(false)
    view.stub(:current_user).and_return(@mock_user)
  end
  
  it 'should show reservations and equipment quick links' do
    render

    assert_select '.home-item>a.quick_link>h2', 'Reservations'
    assert_select '.home-item>a.quick_link>h2', 'Equipment'
  end

  it 'should show monitor quick link' do
    @mock_user.stub(:monitor_access?).and_return true

    render

    assert_select '.home-item>a.quick_link>h2', 'Monitor'
  end

  it 'should show users quick link to admin' do
    mock_admin = stub_model(User)
    mock_admin.stub(:is_admin?).and_return(true)
    view.stub(:current_user).and_return(mock_admin)

    render

    assert_select '.home-item>a.quick_link>h2', 'Users'
    assert_select '.home-item>a.quick_link>h2', 'Monitor'
  end

end
