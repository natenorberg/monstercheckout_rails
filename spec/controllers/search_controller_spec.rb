require 'rails_helper'

RSpec.describe SearchController, :type => :controller do

  describe 'GET index' do
    describe 'when user is signed in' do
      before do
        @mock_user = stub_model(User)
        controller.stub(:current_user).and_return @mock_user
      end

      describe 'searching for user' do
        before do 
          @user = FactoryGirl.create(:user)
        end

        it 'redirects to user page for exact name match' do
          get :index, {keyword: @user.name}
          expect(response).to redirect_to(@user)
        end

        it 'redirects to user page for exact email match' do
          get :index, {keyword: @user.email}
          expect(response).to redirect_to(@user)
        end
      end

      describe 'searching for equipment' do
        before do 
          @equipment = FactoryGirl.create(:equipment)
        end

        it 'redirects to equipment page for exact name match' do
          get :index, {keyword: @equipment.name}
          expect(response).to redirect_to(@equipment)
        end
      end

      describe 'searching for reservation' do
        before do 
          @reservation = FactoryGirl.create(:reservation)
        end

        it 'redirects to reservation page for exact project match' do
          get :index, {keyword: @reservation.project}
          expect(response).to redirect_to(@reservation)
        end
      end

      describe 'fuzzy search' do
        let(:user) { FactoryGirl.create(:user) }
        let(:equipment) { FactoryGirl.create(:equipment) }
        let(:reservation) { FactoryGirl.create(:reservation) }

        before do 
          Search.stub(:find).and_return({:users => user, :equipment => equipment, :reservations => reservation})
        end

        describe 'when user is admin' do
          before do 
            @mock_user.stub(:is_admin?).and_return true
          end

          it 'assigns all results' do
            get :index, {:keyword => 'Blah'}
            expect(assigns(:users)).to eq(user)
            expect(assigns(:equipment)).to eq(equipment)
            expect(assigns(:reservations)).to eq(reservation)
          end
        end

        describe 'when user is monitor' do
          before do 
            @mock_user.stub(:is_admin?).and_return false
            @mock_user.stub(:monitor_access?).and_return true
          end

          it 'assigns equipment and reservations' do
            get :index, {:keyword => 'Blah'}
            expect(assigns(:equipment)).to eq(equipment)
            expect(assigns(:reservations)).to eq(reservation)
          end

          it 'does not assign users' do
            get :index, {:keyword => 'Blah'}
            expect(assigns[:users]).to be_nil
          end
        end

        describe 'when user is normal user' do
          before do 
            @mock_user.stub(:is_admin?).and_return false
            @mock_user.stub(:monitor_access?).and_return false
          end

          it 'assigns equipment' do
            get :index, {:keyword => 'Blah'}
            expect(assigns(:equipment)).to eq(equipment)
          end

          it 'does not assign other results' do
            get :index, {:keyword => 'Blah'}
            expect(assigns(:users)).to be_nil
            expect(assigns(:reservations)).to be_nil
          end
        end
      end
    end

    describe 'when user is not signed in' do
      it 'redirects to the signin path' do
        controller.stub(:current_user).and_return nil

        get :index, {}
        expect(response).to redirect_to(signin_path)
      end
    end
  end
end
