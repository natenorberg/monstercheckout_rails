require 'rails_helper'

RSpec.describe StaticPagesController, :type => :controller do

  def valid_session
    controller.stub(:signed_in?).and_return(true)
  end

  subject { page }

  describe "GET 'home'" do
    it "returns http success" do
      get :home, {}, valid_session
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
