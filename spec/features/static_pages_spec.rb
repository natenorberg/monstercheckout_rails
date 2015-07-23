require 'rails_helper'

describe 'Static Pages' do
  subject { page }

  describe 'Welcome page', type: :request do
    before { visit welcome_path }

    it { should have_title('Welcome') }
    it { should have_link('About') }
    it { should have_link('Help') }
  end

  describe 'Home page', type: :request do
    before { visit home_path }

    describe 'for signed in users' do
      before { sign_in FactoryGirl.create(:user) }

      it { should have_selector('h1', text: 'Welcome to MONSTER Checkout') }
      it { should have_title('Home') }
    end

    describe 'for non-signed in users' do
      it { should have_selector('h1', text: 'Welcome to MONSTER Checkout') }
      it { should have_title('Welcome') }
      it { should have_link('About') }
      it { should have_link('Help') }
    end
  end

  describe 'About page' do
    before { visit about_path }

    it { should have_title('About') }
  end

  describe 'Help page' do
    before { visit help_path }

    it { should have_title('Help') }
  end
end
