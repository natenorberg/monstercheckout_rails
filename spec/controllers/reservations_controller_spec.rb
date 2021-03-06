require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe ReservationsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Reservation. As you add validations to Reservation, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { user_id: FactoryGirl.create(:user).id,
      project: 'Make phat beats',
      out_time: 1.days.ago,
      in_time: 2.days.from_now}
  }

  let(:invalid_attributes) {
    { project: '', out_time: Time.now, in_time: 1.days.ago }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ReservationsController. Be sure to keep this updated too.
  def valid_session
    controller.stub(:user_signed_in).and_return(true)
    @user = stub_model(User)
    @allowed_equipment = [FactoryGirl.create(:equipment), FactoryGirl.create(:equipment)]
    @user.stub(:allowed_equipment).and_return @allowed_equipment
    controller.stub(:current_user).and_return @user
  end

  def non_admin_session
    valid_session
    @user.stub(:is_admin?).and_return false
  end

  def admin_session
    valid_session
    @user.stub(:is_admin?).and_return true
    controller.stub(:user_is_admin).and_return true
  end

  def monitor_session
    valid_session
    monitor = FactoryGirl.create(:monitor)
    @user.stub(:monitor_access?).and_return true
    @monitor_id = monitor.id
    @monitor_name = monitor.name
    @user.stub(:id).and_return @monitor_id
    @user.stub(:name).and_return @monitor_name
  end

  def non_monitor_session
    valid_session
    @non_monitor_id = 44
    @user.stub(:id).and_return @non_monitor_id
    @user.stub(:monitor_access?).and_return false
  end

  def setup_email
    ENV['GMAIL_USERNAME'] = 'test@gmail.com'
    ENV['GMAIL_PASSWORD'] = 'fakepassword'
  end

  def unsetup_email
    ENV['GMAIL_USERNAME'] = nil
    ENV['GMAIL_PASSWORD'] = nil
  end

  before(:each) do
    @gmail_username = ENV['GMAIL_USERNAME']
    @gmail_password = ENV['GMAIL_PASSWORD']
  end

  after(:each) do
    ENV['GMAIL_USERNAME'] = @gmail_username
    ENV['GMAIL_PASSWORD'] = @gmail_password
  end

  describe 'GET index' do
    it 'assigns user reservations as @user_reservations' do
      reservation = Reservation.create! valid_attributes
      controller.stub(:current_user).and_return reservation.user
      get :index, {}
      expect(assigns(:user_reservations)).to eq([reservation])
    end
  end

  describe 'GET archive' do
    describe 'when user is admin' do
      it 'assigns user reservations as @reservations' do
        reservation = FactoryGirl.create(:checkout)
        get :archive, {}, admin_session
        expect(assigns(:reservations)).to eq([reservation])
      end
    end

    describe 'when user is not admin' do
      it 'redirects to root path' do
        get :archive, {}, non_admin_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET show' do
    it 'assigns the requested reservation as @reservation' do
      reservation = Reservation.create! valid_attributes
      get :show, {:id => reservation.to_param}, valid_session
      expect(assigns(:reservation)).to eq(reservation)
    end
  end

  describe 'GET new' do
    it 'assigns a new reservation as @reservation' do
      get :new, {}, valid_session
      expect(assigns(:reservation)).to be_a_new(Reservation)
      expect(assigns(:equipment)).to eq(@allowed_equipment)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested reservation as @reservation' do
      reservation = Reservation.create! valid_attributes
      get :edit, {:id => reservation.to_param}, valid_session
      expect(assigns(:reservation)).to eq(reservation)
      expect(assigns(:equipment)).to eq(@allowed_equipment)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Reservation' do
        expect {
          post :create, {:reservation => valid_attributes}, valid_session
        }.to change(Reservation, :count).by(1)
      end

      it 'assigns a newly created reservation as @reservation' do
        post :create, {:reservation => valid_attributes}, valid_session
        expect(assigns(:reservation)).to be_a(Reservation)
        expect(assigns(:reservation)).to be_persisted
      end

      it 'has a status of requested' do
        post :create, {:reservation => valid_attributes}, valid_session
        expect(assigns(:reservation).status).to eq('requested')
      end

      it 'redirects to the created reservation' do
        post :create, {:reservation => valid_attributes}, valid_session
        expect(response).to redirect_to(Reservation.last)
      end


      describe 'when email is setup' do
        before do
          setup_email
        end

        it 'sends an email notification' do
          User.stub(:approval_needed_mailing_list).and_return([FactoryGirl.create(:admin)])
          expect {
            post :create, {:reservation => valid_attributes}, valid_session
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      describe 'when email is not setup' do
        before do
          unsetup_email
        end

        it 'does not send an email notification' do
          User.stub(:approval_needed_mailing_list).and_return([FactoryGirl.create(:admin)])
          expect {
            post :create, {:reservation => valid_attributes}, valid_session
          }.to change { ActionMailer::Base.deliveries.count }.by(0)
        end
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved reservation as @reservation' do
        post :create, {:reservation => invalid_attributes}, valid_session
        expect(assigns(:reservation)).to be_a_new(Reservation)
      end

      it "re-renders the 'new' template" do
        post :create, {:reservation => invalid_attributes}, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      # If we use from_now in tests we need to define a constant
      let(:new_out_time) { 1.days.from_now.change(:usec => 0) }
      let(:new_in_time) { 2.days.from_now.change(:usec => 0) }
      let(:new_attributes) {
        { project: 'Make more phat beats', out_time: new_out_time, in_time: new_in_time }
      }

      it 'updates the requested reservation' do
        reservation = Reservation.create! valid_attributes
        put :update, {:id => reservation.to_param, :reservation => new_attributes}, valid_session
        reservation.reload
        expect(reservation.project).to eq('Make more phat beats')
        expect(reservation.out_time).to eq(new_out_time)
        expect(reservation.in_time).to eq(new_in_time)
      end

      it 'assigns the requested reservation as @reservation' do
        reservation = Reservation.create! valid_attributes
        put :update, {:id => reservation.to_param, :reservation => valid_attributes}, valid_session
        expect(assigns(:reservation)).to eq(reservation)
      end

      it 'redirects to the reservation' do
        reservation = Reservation.create! valid_attributes
        put :update, {:id => reservation.to_param, :reservation => valid_attributes}, valid_session
        expect(response).to redirect_to(reservation)
      end

      describe 'with approved reservation' do
        it 'unapproves the reservation' do
          reservation = Reservation.create! valid_attributes
          reservation.is_approved = true
          reservation.status = :approved
          reservation.save

          put :update, {:id => reservation.to_param, :reservation => valid_attributes}, valid_session
          reservation.reload
          expect(reservation.is_approved).to eq(false)
          expect(reservation.status).to eq('requested')
        end

        describe 'when email is setup' do
          before do
            setup_email
          end

          it 'sends an email notification' do
            User.stub(:approval_needed_mailing_list).and_return([FactoryGirl.create(:admin)])
            expect {
              post :create, {:reservation => valid_attributes}, valid_session
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end

        describe 'when email is not setup' do
          before do
            unsetup_email
          end

          it 'does not send an email notification' do
            User.stub(:approval_needed_mailing_list).and_return([FactoryGirl.create(:admin)])
            expect {
              post :create, {:reservation => valid_attributes}, valid_session
            }.to change { ActionMailer::Base.deliveries.count }.by(0)
          end
        end
      end

      describe 'with denied reservation' do
        it 'undenies the reservation' do
          reservation = Reservation.create! valid_attributes
          reservation.is_denied = true
          reservation.denied_reason = 'Bad reservation'
          reservation.status = :denied
          reservation.save

          put :update, {:id => reservation.to_param, :reservation => valid_attributes}, valid_session
          reservation.reload
          expect(reservation.is_denied).to eq(false)
          expect(reservation.status).to eq('requested')
          expect(reservation.denied_reason).to eq(nil)
        end

        describe 'when email is setup' do
          before do
            setup_email
          end

          it 'sends an email notification' do
            User.stub(:approval_needed_mailing_list).and_return([FactoryGirl.create(:admin)])
            expect {
              post :create, {:reservation => valid_attributes}, valid_session
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end

        describe 'when email is not setup' do
          before do
            unsetup_email
          end

          it 'does not send an email notification' do
            User.stub(:approval_needed_mailing_list).and_return([FactoryGirl.create(:admin)])
            expect {
              post :create, {:reservation => valid_attributes}, valid_session
            }.to change { ActionMailer::Base.deliveries.count }.by(0)
          end
        end
      end
    end

    describe 'with invalid params' do
      it 'assigns the reservation as @reservation' do
        reservation = Reservation.create! valid_attributes
        put :update, {:id => reservation.to_param, :reservation => invalid_attributes}, valid_session
        expect(assigns(:reservation)).to eq(reservation)
      end

      it "re-renders the 'edit' template" do
        reservation = Reservation.create! valid_attributes
        put :update, {:id => reservation.to_param, :reservation => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe 'DELETE destroy' do
    describe 'when current_user is admin' do
      describe 'when reservation has not been checked out' do
        it 'destroys the requested reservation' do
          reservation = Reservation.create! valid_attributes
          expect {
            delete :destroy, {:id => reservation.to_param}, admin_session
          }.to change(Reservation, :count).by(-1)
        end

        it 'redirects to the reservations list' do
          reservation = Reservation.create! valid_attributes
          delete :destroy, {:id => reservation.to_param}, admin_session
          expect(response).to redirect_to(reservations_url)
        end
      end

      describe 'when reservation has been checked out' do
        it 'does not destroy the requested reservation' do
          reservation = Reservation.create! valid_attributes
          reservation.checked_out_time = 1.days.ago
          reservation.save
          expect {
            delete :destroy, {:id => reservation.to_param}, admin_session
          }.to_not change(Reservation, :count)
        end

        it 'redirects to the root path' do
          reservation = Reservation.create! valid_attributes
          reservation.checked_out_time = 1.days.ago
          reservation.save
          delete :destroy, {:id => reservation.to_param}, admin_session
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'when current_user is not admin' do
      it 'does not destroy the requested reservation' do
        reservation = Reservation.create! valid_attributes
        expect {
          delete :destroy, {:id => reservation.to_param}, non_admin_session
        }.to_not change(Reservation, :count)
      end

      it 'redirects to the reservations list' do
        reservation = Reservation.create! valid_attributes
        delete :destroy, {:id => reservation.to_param}, non_admin_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET approve' do
    before do
      @reservation = FactoryGirl.create(:reservation)
    end

    describe 'when current_user is admin' do

      it 'changes the approved status of the reservation' do
        get :approve, {:id => @reservation.to_param}, admin_session
        @reservation.reload
        expect(@reservation.is_approved?).to eq(true)
        expect(@reservation.status).to eq('approved')
        expect(@reservation.admin_response_time).to_not eq(nil)
      end

      it 'redirects to show page' do
        get :approve, {:id => @reservation.to_param}, admin_session
        expect(response).to redirect_to(@reservation)
      end

      describe 'when user has notifications enabled' do
        describe 'when email is setup' do
          before do
            setup_email
          end

          it 'sends an email' do
            @reservation.user.notify_on_approved = true
            @reservation.save
            expect {
              get :approve, {:id => @reservation.to_param}, admin_session
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end

        describe 'when email is not setup' do
          before do
            unsetup_email
          end

          it 'does not send an email' do
            @reservation.user.notify_on_approved = true
            @reservation.save
            expect {
              get :approve, {:id => @reservation.to_param}, admin_session
            }.to change { ActionMailer::Base.deliveries.count }.by(0)
          end
        end
      end

      describe 'when user does not have notifications enabled' do
        it 'does not send an email' do
          @reservation.user.notify_on_approved = false
          @reservation.user.save
          expect {
            get :approve, {:id => @reservation.to_param}, admin_session
          }.to change { ActionMailer::Base.deliveries.count }.by(0)
        end
      end
    end

    describe 'when current_user is not admin' do
      it 'does not change the approved status of the reservation' do
        @reservation = FactoryGirl.create(:reservation)
        get :approve, {:id => @reservation.to_param}, non_admin_session
        @reservation.reload
        expect(@reservation.is_approved?).to eq(false)
        expect(@reservation.status).to eq('requested')
      end

      it 'redirects to show page' do
        @reservation = FactoryGirl.create(:reservation)
        get :approve, {:id => @reservation.to_param}, non_admin_session

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST deny' do
    let(:reason) { "The administrator doesn't like you" }

    before do
      @reservation = FactoryGirl.create(:reservation)
    end

    describe 'when current_user is admin' do
      it 'changes the denied status of the reservation' do
        post :deny, {:id => @reservation.to_param, :reservation => {:denied_reason => reason}}, admin_session
        @reservation.reload
        expect(@reservation.is_denied?).to eq(true)
        expect(@reservation.status).to eq('denied')
        expect(@reservation.admin_response_time).to_not eq(nil)
        expect(@reservation.denied_reason).to eq(reason)
      end

      it 'redirects to show page' do
        post :deny, {:id => @reservation.to_param, :reservation => {:denied_reason => reason}}, admin_session
        expect(response).to redirect_to(@reservation)
      end

      describe 'when user has notifications enabled' do
        describe 'when email is setup' do
          before do
            setup_email
          end

          it 'sends an email' do
            @reservation.user.notify_on_denied = true
            @reservation.user.save
            expect {
              post :deny, {:id => @reservation.to_param, :reservation => {:denied_reason => reason}}, admin_session
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end

        describe 'when email is not setup' do
          before do
            unsetup_email
          end

          it 'does not send an email' do
            @reservation.user.notify_on_denied = true
            @reservation.user.save
            expect {
              post :deny, {:id => @reservation.to_param, :reservation => {:denied_reason => reason}}, admin_session
            }.to change { ActionMailer::Base.deliveries.count }.by(0)
          end
        end
      end

      describe 'when user does not have notifications enabled' do
        it 'does not send an email' do
          setup_email
          @reservation.user.notify_on_denied = false
          @reservation.user.save
          expect {
            post :deny, {:id => @reservation.to_param, :reservation => {:denied_reason => reason}}, admin_session
          }.to change { ActionMailer::Base.deliveries.count }.by(0)
        end
      end
    end

    describe 'when current_user is not admin' do
      it 'does not change the denied status of the reservation' do
        post :deny, {:id => @reservation.to_param, :reservation => {:denied_reason => reason}}, non_admin_session
        @reservation.reload
        expect(@reservation.is_denied?).to eq(false)
        expect(@reservation.status).to eq('requested')
      end

      it 'redirects to show page' do
        post :deny, {:id => @reservation.to_param, :reservation => {:denied_reason => reason}}, non_admin_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET checkout' do
    describe 'when current_user is monitor' do
      it 'assigns the requested reservation as @reservation' do
        reservation = Reservation.create! valid_attributes
        reservation.approved!
        get :checkout, {:id => reservation.to_param}, monitor_session
        expect(assigns(:reservation)).to eq(reservation)
      end

      describe 'when reservation is not approved' do
        it 'redirects to root_path' do
          reservation = Reservation.create! valid_attributes
          get :checkout, {:id => reservation.to_param}, monitor_session
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'when current_user is not monitor' do
      it 'redirects to root_path' do
        reservation = Reservation.create! valid_attributes
        get :checkout, {:id => reservation.to_param}, non_monitor_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST checkout_update' do
    describe 'when current_user is monitor' do
      before do
        @reservation = Reservation.create! valid_attributes
        @reservation.approved!
      end

      it 'updates the reservation with checkout information' do
        put :checkout_update, {:id => @reservation.to_param, :reservation => {:check_out_comments => 'checkout comments'}}, monitor_session
        @reservation.reload

        expect(@reservation.check_out_comments).to eq('checkout comments')
        expect(@reservation.checked_out_by_id).to eq(@monitor_id)
        expect(@reservation.checked_out_time).to_not eq(nil)
      end

      describe 'when user has notifications enabled' do
        describe 'when email is setup' do
          before do
            setup_email
          end

          it 'sends an email' do
            @reservation.user.notify_on_checked_out = true
            @reservation.user.save
            expect {
              put :checkout_update, {:id => @reservation.to_param, :reservation => {:check_out_comments => 'checkout comments'}}, monitor_session
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end

        describe 'when email is not setup' do
          before do
            unsetup_email
          end

          it 'does not send an email' do
            @reservation.user.notify_on_checked_out = true
            @reservation.user.save
            expect {
              put :checkout_update, {:id => @reservation.to_param, :reservation => {:check_out_comments => 'checkout comments'}}, monitor_session
            }.to change { ActionMailer::Base.deliveries.count }.by(0)
          end
        end
      end

      describe 'when user does not have notifications enabled' do
        it 'does not send an email' do
          @reservation.user.notify_on_checked_out = false
          @reservation.user.save
          expect {
            put :checkout_update, {:id => @reservation.to_param, :reservation => {:check_out_comments => 'checkout comments'}}, monitor_session
          }.to change { ActionMailer::Base.deliveries.count }.by(0)
        end
      end

      describe 'when reservation is not approved' do
        it 'redirects to root_path' do
          reservation = Reservation.create! valid_attributes
          put :checkout_update, {:id => reservation.to_param, :reservation => {:check_out_comments => 'checkout comments'}}, monitor_session
          expect(response).to redirect_to(root_path)
        end
      end

      describe 'when current_user is not monitor' do
        it 'redirects to root_path' do
          reservation = Reservation.create! valid_attributes
          put :checkout_update, {:id => reservation.to_param, :reservation => {:check_out_comments => 'checkout comments'}}, non_monitor_session
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'GET checkin' do
    describe 'when current_user is monitor' do
      it 'assigns the requested reservation as @reservation' do
        reservation = Reservation.create! valid_attributes
        get :checkin, {:id => reservation.to_param}, monitor_session
        expect(assigns(:reservation)).to eq(reservation)
      end
    end

    describe 'when reservation can not be checked in' do
      it 'redirects to root_path' do
        reservation = Reservation.create! valid_attributes
        reservation.stub(:can_checkin?).and_return false
        get :checkin, {:id => reservation.to_param}, monitor_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'when current_user is not monitor' do
      it 'redirects to root_path' do
        reservation = Reservation.create! valid_attributes
        get :checkin, {:id => reservation.to_param}, non_monitor_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST checkin_update' do
    describe 'when current_user is monitor' do
      describe 'when returned on time' do
        before do
          @reservation = FactoryGirl.create(:checkout)
        end

        it 'updates the reservation with checkin information' do
          put :checkin_update, {:id => @reservation.to_param, :reservation => {:check_in_comments => 'checkin comments'}}, monitor_session
          @reservation.reload

          expect(@reservation.status).to eq('returned')
          expect(@reservation.check_in_comments).to eq('checkin comments')
          expect(@reservation.checked_in_by_id).to eq(@monitor_id)
          expect(@reservation.checked_in_time).to_not eq(nil)
        end

        describe 'when user has notifications enabled' do
          describe 'when email is setup' do
            before do
              setup_email
            end

            it 'sends an email' do
              @reservation.user.notify_on_checked_in = true
              @reservation.user.save
              expect {
                put :checkin_update, {:id => @reservation.to_param, :reservation => {:check_in_comments => 'checkin comments'}}, monitor_session
              }.to change { ActionMailer::Base.deliveries.count }.by(1)
            end
          end

          describe 'when email is not setup' do
            before do
              unsetup_email
            end

            it 'does not send an email' do
              @reservation.user.notify_on_checked_in = true
              @reservation.user.save
              expect {
                put :checkin_update, {:id => @reservation.to_param, :reservation => {:check_in_comments => 'checkin comments'}}, monitor_session
              }.to change { ActionMailer::Base.deliveries.count }.by(0)
            end
          end
        end

        describe 'when user does not have notifications enabled' do
          it 'does not send an email' do
            @reservation.user.notify_on_checked_in = false
            @reservation.user.save
            expect {
              put :checkin_update, {:id => @reservation.to_param, :reservation => {:check_in_comments => 'checkin comments'}}, monitor_session
            }.to change { ActionMailer::Base.deliveries.count }.by(0)
          end
        end
      end

      describe 'when returned late' do
        it 'marks the reservation as returned late' do
          reservation = FactoryGirl.create(:checkout)
          reservation.in_time = 1.hours.ago
          reservation.save

          put :checkin_update, {:id => reservation.to_param, :reservation => {:check_in_comments => 'checkin comments'}}, monitor_session
          reservation.reload

          expect(reservation.status).to eq('returned_late')
        end
      end

      describe 'when reservation is not checked out' do
        it 'redirects to root_path' do
          reservation = Reservation.create! valid_attributes
          put :checkin_update, {:id => reservation.to_param, :reservation => {:check_in_comments => 'checkin comments'}}, monitor_session
          expect(response).to redirect_to(root_path)
        end
      end

      describe 'when current_user is not monitor' do
        it 'redirects to root_path' do
          reservation = Reservation.create! valid_attributes
          put :checkin_update, {:id => reservation.to_param, :reservation => {:check_in_comments => 'checkin comments'}}, non_monitor_session
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end

