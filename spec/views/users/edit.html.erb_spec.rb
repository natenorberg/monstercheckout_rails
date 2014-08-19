require 'rails_helper'

RSpec.describe 'users/edit', :type => :view do
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

  it 'renders the edit user form' do
    render

    assert_select 'form[action=?][method=?]', user_path(@user), 'post' do

      assert_select 'input#user_name[name=?]', 'user[name]'

      assert_select 'input#user_email[name=?]', 'user[email]'
    end
  end
end
