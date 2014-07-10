require "rails_helper"

def sign_in(user)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"

  cookies[:remember_token] = user.remember_token
end

describe "Static Pages" do
  subject { page }

  describe "Welcome page", type: :request do
    before { visit welcome_path }

    it { should have_title('Welcome') }
  end

  describe "Home page", type: :request do
    before { visit home_path }

    describe "for signed in users" do
      before { sign_in FactoryGirl.create(:user) }

      it { should have_selector('h1', text: "Welcome to MONSTER Checkout") }
      it { should have_title('Home') }
    end

    describe "for non-signed in users" do
      it { should have_selector('h1', text: 'Welcome to MONSTER Checkout') }
      it { should have_title('Welcome') }
    end
  end

  describe "About page" do
    before { visit about_path }

    it { should have_title('About') }
  end
end