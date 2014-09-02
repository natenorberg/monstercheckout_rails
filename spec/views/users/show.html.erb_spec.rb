require 'rails_helper'

RSpec.describe 'users/show', :type => :view do
  before(:each) do
    mock_user = stub_model(User)
    mock_user.stub(:is_admin?).and_return(true)
    view.stub(:current_user).and_return(mock_user)
    @permission = FactoryGirl.create(:permission)
    @user = assign(:user, User.create!(
      :name => 'Name',
      :email => 'email@example.fake',
      :password => 'password1',
      :password_confirmation => 'password1',
      :permissions => [@permission]
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/email@example.fake/)
    expect(rendered).to match /Permissions/
    expect(rendered).to have_selector 'ul.permissions-list>li', :text => @permission.name
    expect(rendered).to render_template(:partial => 'shared/_icon_reservation_list')
  end

  it 'renders breadcrumbs' do
    render

    verify_breadcrumbs ['Admin', 'Users', @user.name]
  end
end
