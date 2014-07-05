# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#

require 'rails_helper'

describe "User" do
  
  before { @user = User.new(name: 'Example User', email: 'user@example.com', 
                            password: 'password1', password_confirmation: 'password1') }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
