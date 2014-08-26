require 'rails_helper'

RSpec.describe MonitorController, :type => :controller do
  

  describe 'GET dashboard' do
    before(:each) do
    	controller.stub(:user_signed_in).and_return true

    	@mock_user = stub_model(User)
	    @mock_user.stub(:monitor_access?).and_return(true)
	    controller.stub(:current_user).and_return(@mock_user)

    	@checkouts = [FactoryGirl.create(:approved_reservation), FactoryGirl.create(:approved_reservation)]
    	@checkins = [FactoryGirl.create(:checkout), FactoryGirl.create(:checkout)]
    end

    it 'should assign checkouts and checkins' do
    	get :dashboard, {}
    	expect(assigns(:checkouts)).to eq(@checkouts)
    	expect(assigns(:checkins)).to eq(@checkins)
    end

    it 'redirects to the root url if user does not have permission' do
        @mock_user.stub(:monitor_access?).and_return false

        get :dashboard, {}

        expect(response).to redirect_to(root_path)
    end
  end
end