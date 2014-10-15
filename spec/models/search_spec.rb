require 'rails_helper'

RSpec.describe Search, :type => :model do
  
  describe 'find' do

    describe 'users' do
      before do 
        # Add two users with 'Person' in the name
        @users = []
        2.times { @users << FactoryGirl.create(:user) }
      end

      it 'finds matching users' do
        results = Search.find('Person')
        expect(results[:users]).to eq(@users)
      end
    end

    describe 'equipment' do
      before do 
        @equipment = []
        2.times { @equipment << FactoryGirl.create(:equipment) }
      end

      it 'finds matching equipment' do
        results = Search.find('Mic')
        expect(results[:equipment]).to eq(@equipment)
      end
    end

    describe 'reservations' do
      before do 
        @reservations = []
        2.times { @reservations << FactoryGirl.create(:reservation)}
      end

      it 'finds matching reservations' do
        results = Search.find('Record')
        expect(results[:reservations]).to eq(@reservations)
      end
    end
  end
end