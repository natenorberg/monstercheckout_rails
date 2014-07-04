require "rails_helper"

describe "Static Pages" do
  subject { page }

  describe "Welcome page", type: :request do
    before { visit welcome_path }

    it { should have_selector('h1', text: "Welcome to MONSTER Checkout") }
    it { should have_title('Welcome') }
  end

  describe "Home page", type: :request do
    before { visit home_path }

    it { should have_selector('h1', text: 'Welcome to MONSTER Checkout') }
    it { should have_title('Home') }
  end
end