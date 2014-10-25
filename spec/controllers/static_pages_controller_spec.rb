require 'rails_helper'

RSpec.describe StaticPagesController, :type => :controller do

  def valid_session
    controller.stub(:signed_in?).and_return(true)
  end

  subject { page }

  describe "GET 'home'" do
    it 'returns http success' do
      get :home, {}, valid_session
      expect(response).to be_success
    end
  end

  describe "GET 'welcome'" do
    it 'returns http success' do
      get 'welcome'
      expect(response).to be_success
    end
  end

  describe "GET 'about" do
    it 'returns http success' do
      get 'about'
      expect(response).to be_success
    end
  end

  describe "GET 'help" do
    it 'returns http success' do
      get 'help'
      expect(response).to be_success
    end
  end

  describe "GET 'v1_1" do
    it 'returns http success' do
      get 'v1_1'
      expect(response).to be_success
    end
  end

end
