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

      assert_select 'input#user_email[name=?][type=?]', 'user[email]', 'email'

      assert_select 'input[name=?]', 'user[permission_ids][]'
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

    it 'should render notification settings' do
      render

      assert_select 'input[name=?]', 'user[notify_on_approved]'
      assert_select 'input[name=?]', 'user[notify_on_denied]'
      assert_select 'input[name=?]', 'user[notify_on_checked_out]'
      assert_select 'input[name=?]', 'user[notify_on_checked_in]'
    end

    describe 'when user is admin' do
      before do 
        @user.is_admin = true
      end

      it 'should render admin notification settings' do
        render

        assert_select 'input[name=?]', 'user[notify_on_approval_needed]'
      end
    end

    describe 'when user is not admin' do
      before do 
        @user.is_admin = false
      end

      it 'should not render admin notification settings' do
        render

        assert_select 'input[name=?]', 'user[notify_on_approval_needed]', count: 0
      end
    end
  end

  describe 'when user is not current_user' do
    it 'renders breadcrumbs' do
      render

      verify_breadcrumbs ['Admin', 'Users', @user.name, 'Edit']
    end

    it 'should not render notification settings' do
      render

      assert_select 'input[name=?]', 'user[notify_on_approved]', count: 0
      assert_select 'input[name=?]', 'user[notify_on_denied]', count: 0
      assert_select 'input[name=?]', 'user[notify_on_checked_out]', count: 0
      assert_select 'input[name=?]', 'user[notify_on_checked_in]', count: 0
    end
  end
end
