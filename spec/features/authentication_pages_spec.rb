require 'rails_helper'

describe "Authentication" do
  
  subject { page }

  describe "login page" do
    before { visit signin_path }

    it { should have_selector('h1', 'Sign in') }
    it { should have_title('Sign in') }
  end
end