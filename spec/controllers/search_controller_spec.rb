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

        describe 'as an admin' do
          before do
            @mock_user.stub(:is_admin?).and_return true
          end

          it 'redirects to user page for exact name match' do
            get :index, {keyword: @user.name}
            expect(response).to redirect_to(@user)
          end

          it 'assigns users if matching more than one' do
            other_user = FactoryGirl.create(:user)
            other_user.name = @user.name
            other_user.save

            get :index, {keyword: @user.name}
            expect(assigns(:users)).to eq([@user, other_user])
          end

          it 'redirects to user page for exact email match' do
            get :index, {keyword: @user.email}
            expect(response).to redirect_to(@user)
          end
        end

        describe 'as a non-admin' do
          before do
            @mock_user.stub(:is_admin?).and_return false
          end

          it 'does not redirect to user page' do
            get :index, {keyword: @user.email}
            expect(response).to_not redirect_to(@user)
          end
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

        it 'assigns equipment if matching more than one' do
          other_equipment = FactoryGirl.create(:equipment)
          other_equipment.name = @equipment.name
          other_equipment.save

          get :index, {keyword: @equipment.name}
          expect(assigns(:equipment)).to eq([@equipment, other_equipment])
        end
      end

      describe 'searching for reservation' do
        before do
          @reservation = FactoryGirl.create(:reservation)
        end

        describe 'as a monitor' do
          before do
            @mock_user.stub(:is_admin?).and_return false
            @mock_user.stub(:monitor_access?).and_return true
          end

          it 'redirects to reservation page for exact project match' do
            get :index, {keyword: @reservation.project}
            expect(response).to redirect_to(@reservation)
          end

          it 'assigns reservations if matching more than one' do
            other_reservation = FactoryGirl.create(:reservation)
            other_reservation.project = @reservation.project
            other_reservation.save

            get :index, {keyword: @reservation.project}
            expect(assigns(:reservations)).to eq([@reservation, other_reservation])
          end
        end

        describe 'as a non-monitor' do
          before do
            @mock_user.stub(:is_admin?).and_return false
            @mock_user.stub(:is_monitor?).and_return false
          end

          it 'does not redirect to reservation page' do
            get :index, {keyword: @reservation.project}
            expect(response).to_not redirect_to(@reservation)
          end
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
