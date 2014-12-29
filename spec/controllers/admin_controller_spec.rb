require 'rails_helper'

RSpec.describe AdminController, :type => :controller do
  
  describe 'GET dashboard' do
    before do
      controller.stub(:user_signed_in).and_return true

      @mock_user = stub_model(User)
      @mock_user.stub(:is_admin?).and_return(true)
      controller.stub(:current_user).and_return(@mock_user)

      @permissions = [FactoryGirl.create(:permission), FactoryGirl.create(:permission)]
      @reservations_pending = [FactoryGirl.create(:reservation), FactoryGirl.create(:reservation)]
    end

    it 'should assign users and permissions' do
      get :dashboard, {}
      expect(assigns(:permissions)).to eq(@permissions)
      expect(assigns(:reservations_pending)).to eq(@reservations_pending)
    end

    it 'redirects to the root url if user does not have permission' do
        @mock_user.stub(:is_admin?).and_return false

        get :dashboard, {}

        expect(response).to redirect_to(root_path)
        expect(true).to eq(false) #testing travis build
    end
  end
end
