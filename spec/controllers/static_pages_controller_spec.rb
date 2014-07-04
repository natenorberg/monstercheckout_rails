require 'rails_helper'

RSpec.describe StaticPagesController, :type => :controller do

  subject { page }

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      expect(response).to be_success
    end
  end

  describe "GET 'welcome'" do
    it "returns http success" do
      get 'welcome'
      expect(response).to be_success
    end
  end

end
