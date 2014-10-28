require 'rails_helper'

RSpec.describe 'users/new', :type => :view do
  before(:each) do
    assign(:user, User.new(
      :name => 'MyString',
      :email => 'MyString'
    ))
  end

  it 'renders new user form' do
    render

    assert_select 'form[action=?][method=?]', users_path, 'post' do

      assert_select 'input#user_name[name=?]', 'user[name]'

      assert_select 'input#user_email[name=?][type=?]', 'user[email]', 'email'

      assert_select 'input[name=?]', 'user[permission_ids][]'
    end
  end

  it 'should render breadcrumbs' do
    render

    verify_breadcrumbs ['Admin', 'Users', 'New']
  end
end
