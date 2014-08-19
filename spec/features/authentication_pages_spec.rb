require 'rails_helper'

describe 'Authentication' do
  
  subject { page }

  describe 'login page' do
    before { visit signin_path }

    it { should have_selector('h1', 'Sign in') }
    it { should have_title('Sign in') }

    describe 'with invalid information' do
      before { click_button 'Sign in' }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-danger', text: 'Invalid') }
    end

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in 'Email',    with: user.email
        fill_in 'Password', with: user.password
        click_button 'Sign in'
      end

      it { should have_title('Home') }
    end
  end
end