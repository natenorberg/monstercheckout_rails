require "rails_helper"

def sign_in(user)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"

  cookies[:remember_token] = user.remember_token
end

describe "Reservation pages" do
  subject { page }

  describe "index page" do
    
    describe "without signing in" do
      before { visit reservations_path }

      it { should have_title('Sign in') }
    end
  end

  # TODO: Add sign in redirect tests for other views once we have a factory
end