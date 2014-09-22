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

describe 'User' do

  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it 'should respond to attributes' do
    expect(@user).to respond_to(:name)
    expect(@user).to respond_to(:email)
    expect(@user).to respond_to(:password)
    expect(@user).to respond_to(:password_confirmation)
    expect(@user).to respond_to(:password_digest)
    expect(@user).to respond_to(:is_admin?)
    expect(@user).to respond_to(:is_monitor?)
    expect(@user).to respond_to(:reservations)
    expect(@user).to respond_to(:monitor_checkouts)
    expect(@user).to respond_to(:monitor_checkins)
    expect(@user).to respond_to(:permissions)
    expect(@user).to respond_to(:notify_on_approval_needed?)
  end

  it 'should have a valid factory' do
    expect(@user).to be_valid
  end

  # Name tests
  it 'is invalid without a name' do
    @user.name = ''
    expect(@user).to_not be_valid
  end

  # Email tests
  it 'is invalid without an email' do
    @user.email = ''
    expect(@user).to_not be_valid
  end

  it 'is invalid when email format is invalid' do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                       foo@bar_baz.com foo@bar+baz.com]
    addresses.each do |invalid_address|
      @user.email = invalid_address
      expect(@user).to_not be_valid
    end
  end

  it 'is valid when email format is valid' do
    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    addresses.each do |valid_address|
      @user.email = valid_address
      expect(@user).to be_valid
    end
  end

  it 'is invalid when email has already been taken' do
    @user.save
    other_user = @user.dup
    other_user.email = @user.email.upcase

    expect(other_user).to_not be_valid
  end

  describe 'email address with mixed case' do
    let(:mixed_case_email) { 'Foo@ExAMPle.CoM' }

    it 'should be saved as all lower-case' do
        @user.email = mixed_case_email
        @user.save

        expect(@user.reload.email).to eq(mixed_case_email.downcase)
    end
  end

  # Password/confirmation tests
  it 'should be invalid when password is blank' do
    @user.password = @user.password_confirmation = ''
    expect(@user).to_not be_valid
  end

  it "should be invalid when password doesn't match confirmation" do
    @user.password_confirmation = 'mismatch'
    expect(@user).to_not be_valid
  end

  it 'should be invalid when password is too short' do
    @user.password = @user.password_confirmation = 'n' * 5
    expect(@user).to_not be_valid
  end

  # Authentication tests
  describe 'return value of authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    it 'should authenticate with valid password' do
      expect(@user).to eq(found_user.authenticate(@user.password))
    end

    it 'should not authenticate with invalid password' do
      user_for_invalid_password = found_user.authenticate('invalid')

      expect(@user).to_not eq(user_for_invalid_password)
      expect(user_for_invalid_password).to eq(false)
    end
  end

  # Remember token tests
  it 'should create remember_token on save' do
    @user.save
    expect(@user.remember_token).to_not be_blank
  end

  describe 'monitor_access?' do

    it 'should be true if user is monitor' do
      @user.is_monitor = true
      @user.is_admin = false

      expect(@user.monitor_access?).to eq(true)
    end

    it 'should be true if user is admin' do
      @user.is_monitor = false
      @user.is_admin = true

      expect(@user.monitor_access?).to eq(true)
    end

    it 'should not be true otherwise' do
      @user.is_monitor = false
      @user.is_admin = false

      expect(@user.monitor_access?).to eq(false)
    end
  end

  # Allowed equipment tests
  describe 'allowed_equipment' do
    before do
      @permission = FactoryGirl.create(:permission)
      @equipment = FactoryGirl.create(:equipment)
      @permission.stub(:equipment).and_return [@equipment]
      @user.stub(:permissions).and_return [@permission]
    end

    it 'should return a list of equipment the user can use' do
      expect(@user.allowed_equipment).to eq([@equipment])
    end
  end
end
