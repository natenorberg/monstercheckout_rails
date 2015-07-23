require 'rails_helper'

describe 'Reservation pages' do
  describe 'index page', type: :request do
    describe 'without signing in' do
      before { visit reservations_path }

      it 'should redirect to sign in page' do
        expect(page).to have_title('Sign in')
      end
    end

    describe 'after signing in' do
      describe 'as a regular user' do
        let(:user) { FactoryGirl.create(:user) }
        before do
          sign_in(user)
          visit reservations_path
        end

        it 'should have title "Reservations"' do
          expect(page).to have_title('Reservations')
        end
      end

      describe 'as an admin' do
        # TODO: Test admin stuff
      end
    end
  end

  # TODO: Add sign in redirect tests for other views once we have a factory
end
