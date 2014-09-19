require 'rails_helper'

RSpec.describe 'users/password', :type => :view do
  before(:each) do
    mock_user = stub_model(User)
    mock_user.stub(:is_admin?).and_return(true)
    view.stub(:current_user).and_return(mock_user)
    @user = assign(:user, User.create!(
      :name => 'MyString',
      :email => 'my@email.invalid',
      :password => 'password1',
      :password_confirmation => 'password1'
    ))
  end

  it 'renders the edit password user form' do
    render

    assert_select 'form[action=?][method=?]', user_path(@user), 'post' do

      assert_select 'input#user_password[type="password"][name=?]', 'user[password]'

      assert_select 'input#user_password_confirmation[type="password"][name=?]', 'user[password_confirmation]'
    end
  end

  describe 'when user is current_user' do
    before do 
      view.stub(:current_user).and_return @user
    end

    it 'should not render breadcrumbs' do
      render

      assert_select 'ol.breadcrumb', :count => 0
    end
  end

  describe 'when user is not current_user' do
    it 'renders breadcrumbs' do
      render

      verify_breadcrumbs ['Admin', 'Users', @user.name, 'Edit Password']
    end
  end
end
