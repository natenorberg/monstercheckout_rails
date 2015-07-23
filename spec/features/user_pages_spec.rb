require 'rails_helper'

describe 'User pages' do
  subject { page }

  describe 'index page', type: :request do

    describe 'without signing in' do
      before { visit users_path }

      it { should have_title('Sign in') }
    end

    describe 'after signing in' do

      describe 'as an admin' do
        # TODO: test admin stuff
      end

      describe 'as a non-admin' do
        let(:user) { FactoryGirl.create(:user) }
        before do
          sign_in(user)
          visit users_path
        end

        it { should have_title('Home') }
      end
    end
  end

  describe 'show page', type: :request do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:admin) }
    before { user.save! }

    describe 'without signing in' do
      before { visit user_path(user) }

      it { should have_title('Sign in') }
    end

    describe 'after signing in' do

      describe 'as an admin' do
        before do
          sign_in(admin)
          visit user_path(user)
        end

        it { should have_title(user.name) }
        it { should have_link('Edit') }
        it { should have_link('Delete') }
      end

      describe 'as correct user' do
        before do
          sign_in(user)
          visit user_path(user)
        end

        it { should have_title('Profile') }
      end

      describe 'as other user' do
        before do
          sign_in(user)
          visit user_path(other_user)
        end

        it { should have_title('Home') }
      end
    end
  end

  describe 'edit page', type: :request do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:admin) }
    before { user.save! }

    describe 'without signing in' do
      before { visit edit_user_path(user) }

      it { should have_title('Sign in') }
    end

    describe 'after signing in' do

      describe 'as an admin' do
        before do
          sign_in(admin)
          visit edit_user_path(user)
        end

        it { should have_title(user.name) }
      end

      describe 'as correct user' do
        before do
          sign_in(user)
          visit edit_user_path(user)
        end

        it { should have_title('Settings') }
      end

      describe 'as other user' do
        before do
          sign_in(user)
          visit edit_user_path(other_user)
        end

        it { should have_title('Home') }
      end
    end
  end
end
