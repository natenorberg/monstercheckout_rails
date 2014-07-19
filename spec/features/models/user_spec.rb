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
  
  before { @user = User.new(name: "Example User", 
                            email: "user@example.com", 
                            password: "password1", 
                            password_confirmation: "password1") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }

  it { should be_valid }

  # Name tests
  describe "when name is blank" do
    before {@user.name = ""}
    it { should_not be_valid }
  end

  # Email tests
  describe "when email is blank" do
    before {@user.email = ""}
    it { should_not be_valid }
  end

  describe "when email format is invalid" do 
    it "should be invalid" do 
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                       foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end 
    end 
  end 

  describe "when email format is valid" do 
    it "should be valid" do 
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          @user.should be_valid
        end 
    end 
  end 

  describe "when email has already been taken" do
    before do
      other_user = @user.dup
      other_user.email = @user.email.upcase
      other_user.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do 
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
        @user.email = mixed_case_email
        @user.save
        @user.reload.email.should == mixed_case_email.downcase
    end 
  end 

  # Password/confirmation tests
  describe "when password is blank" do
    before { @user.password = @user.password_confirmation = "" }
    it { should_not be_valid }
  end

  describe "when password does not match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password is less than 6 characters" do
    before { @user.password = @user.password_confirmation = 'n' * 5 }
    it { should_not be_valid }
  end

  # Authentication tests
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should eq(false) }
    end
  end

  # Remember token tests
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
