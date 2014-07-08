require "rails_helper"

def sign_in(user)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"

  cookies[:remember_token] = user.remember_token
end

describe "User pages" do
  subject { page }

  describe "index page", type: :request do
    
    describe "without signing in" do
      before { visit users_path }

      it { should have_title('Sign in') }
    end

    describe "after signing in" do

      describe "as an admin" do
        # TODO: test admin stuff
      end

      describe "as a non-admin" do
        let(:user) { FactoryGirl.create(:user) }
        before do 
          sign_in(user)
          visit users_path
        end
        
        it { should have_title('Home') }
      end
    end
  end  
  # TODO: Add sign in redirect tests for other views once we have a factory
end