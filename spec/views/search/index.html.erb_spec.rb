require 'rails_helper'

RSpec.describe 'search/index', :type => :view do
  before(:each) do
    @user = stub_model(User)
    @user.stub(:is_admin?).and_return(true)
    view.stub(:current_user).and_return(@user)
    assign(:equipment, [ FactoryGirl.build(:equipment) ])
    assign(:users, [ FactoryGirl.build(:user) ])
    assign(:reservations, [ FactoryGirl.build(:reservation) ])
  end

  it 'renders search results' do
    render

    assert_select '#equipment_search_results>h3', :text => 'Equipment'
    assert_select '#equipment_search_results>ul.search-result-list'

    assert_select '#user_search_results>h3', :text => 'Users'
    assert_select '#user_search_results>ul.search-result-list'

    assert_select '#reservation_search_results>h3', :text => 'Reservations'
    assert_select '#reservation_search_results>ul.search-result-list'
  end
end
