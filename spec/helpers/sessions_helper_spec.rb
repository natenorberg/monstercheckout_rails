require 'rails_helper'

RSpec.describe SessionsHelper, :type => :helper do
  
  it 'should sign in user' do
    mock_user = stub_model(User)
    mock_user.stub(:remember_token).and_return('totem')
    helper.sign_in(mock_user)

    expect(helper.current_user).to eq(mock_user)
    expect(cookies[:remember_token]).to eq('totem')
  end

  describe 'signed_in?' do
    it 'should be false when current_user is nil' do
      expect(helper.signed_in?).to eq(false)
    end

    it 'should be true when current_user is not nil' do
      mock_user = stub_model(User)
      helper.current_user = mock_user

      expect(helper.signed_in?).to eq(true)
    end
  end

end
