require 'rails_helper'

def sign_in(user)
  visit signin_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'

  cookies[:remember_token] = user.remember_token
end

describe 'Equipment pages' do
  subject { page }

  describe 'index page', type: :request do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      sign_in(user)
      visit equipment_index_path
    end

    it { should have_title('Equipment') }
  end

  describe 'show page', type: :request do
    let(:mic) { FactoryGirl.create(:equipment) }
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in(user)
      visit equipment_path(mic)
    end

    it { should have_title(mic.name) }
  end

  describe 'new page', type: :request do
    
    describe 'without signing in' do
      before { visit new_equipment_path }

      it { should have_title('Sign in') }
    end

    describe 'as non-admin user' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in(user)
        visit new_equipment_path
      end

      it { should have_title('Home') }
    end

    describe 'as admin' do
      let(:user) { FactoryGirl.create(:admin) }
      before do
        sign_in(user)
        visit new_equipment_path
      end

      it { should have_title('New Equipment') }
    end
  end

  describe 'edit page', type: :request do
    let(:equipment) { FactoryGirl.create(:equipment) }
    
    describe 'without signing in' do
      before { visit edit_equipment_path(equipment) }

      it { should have_title('Sign in') }
    end

    describe 'as non-admin user' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in(user)
        visit edit_equipment_path(equipment)
      end

      it { should have_title('Home') }
    end

    describe 'as admin' do
      let(:user) { FactoryGirl.create(:admin) }
      before do
        sign_in(user)
        visit edit_equipment_path(equipment)
      end

      it { should have_title("Editing #{equipment.name}") }
    end
  end
end