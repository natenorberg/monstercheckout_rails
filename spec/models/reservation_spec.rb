# == Schema Information
#
# Table name: reservations
#
#  id                 :integer          not null, primary key
#  project            :string(255)
#  in_time            :datetime
#  out_time           :datetime
#  checked_out_time   :datetime
#  checked_in_time    :datetime
#  is_approved        :boolean
#  check_out_comments :text
#  check_in_comments  :text
#  created_at         :datetime
#  updated_at         :datetime
#  user_id            :integer
#  checked_out_by_id  :integer
#  checked_in_by_id   :integer
#  status             :integer
#

require 'rails_helper'

RSpec.describe Reservation, :type => :model do

  before { @reservation = FactoryGirl.create(:reservation) }

  it 'should respond to attributes' do
    expect(@reservation).to respond_to(:project)
    expect(@reservation).to respond_to(:out_time)
    expect(@reservation).to respond_to(:in_time)
    expect(@reservation).to respond_to(:checked_out_time)
    expect(@reservation).to respond_to(:checked_in_time)
    expect(@reservation).to respond_to(:is_approved?)
    expect(@reservation).to respond_to(:is_denied?)
    expect(@reservation).to respond_to(:admin_response_time)
    expect(@reservation).to respond_to(:check_out_comments)
    expect(@reservation).to respond_to(:check_in_comments)
    expect(@reservation).to respond_to(:user_id)
    expect(@reservation).to respond_to(:checked_out_by_id)
    expect(@reservation).to respond_to(:checked_in_by_id)
    expect(@reservation).to respond_to(:equipment)
    expect(@reservation).to respond_to(:status)
  end

  it 'should have valid factories' do
    expect(@reservation).to be_valid

    @reservation = FactoryGirl.create(:checkout)
    expect(@reservation).to be_valid

    @reservation = FactoryGirl.create(:checkin)
    expect(@reservation).to be_valid
  end

  # Validation tests 

  it 'should be invalid without a project' do
    @reservation.project = ''
    expect(@reservation).to_not be_valid
  end

  it 'should be invalid without out_time' do
    @reservation.out_time = nil
    expect(@reservation).to_not be_valid
  end

  it 'should be invalid without in_time' do
    @reservation.in_time = nil
    expect(@reservation).to_not be_valid
  end

  it 'should be invalid if out_time is after in_time' do
    @reservation.out_time = 50.days.from_now
    expect(@reservation).to_not be_valid
  end

  it 'should be invalid if checking out without check_out_comments' do
    @reservation.checked_out_time = Time.now
    @reservation.check_out_comments = ''

    expect(@reservation).to_not be_valid
  end

  it 'should be invalid if checking_in without check_in_comments' do
    @reservation = FactoryGirl.create(:checkout)
    @reservation.checked_in_time = Time.now
    @reservation.check_in_comments = ''

    expect(@reservation).to_not be_valid
  end

  it 'should be invalid if changing checked_out_time' do
    @reservation = FactoryGirl.create(:checkout)
    @reservation.checked_out_time = Time.now

    expect(@reservation).to_not be_valid
  end

  it 'should be invalid if changing checked_in_time' do
    @reservation = FactoryGirl.create(:checkin)
    @reservation.checked_in_time = Time.now

    expect(@reservation).to_not be_valid
  end

  it 'should be invalid if trying to check in without checking out' do
    @reservation.checked_in_time = Time.now
    @reservation.check_in_comments = 'What am i even doing?'

    expect(@reservation).to_not be_valid
  end

  # Helper method tests
  describe 'checked_out?' do
    
    it 'should return true if checked_out is set' do
      @reservation = FactoryGirl.create(:checkout)
      expect(@reservation.checked_out?).to eq(true)
    end

    it 'should return false if checked_out is not set' do
      @reservation = FactoryGirl.create(:reservation)
      expect(@reservation.checked_out?).to eq(false)
    end
  end

  describe 'can_cancel?' do
    
    it 'should return false if not current user' do
      another_user = FactoryGirl.create(:user)
      expect(@reservation.can_cancel?(another_user)).to eq(false)
    end

    it 'should return true if not checked out' do
      expect(@reservation.can_cancel?(@reservation.user)).to eq(true)
    end

    it 'should return false if checked out' do
      @reservation.stub(:checked_out?).and_return true
      expect(@reservation.can_cancel?(@reservation.user)).to eq(false)
    end
  end

  describe 'checked_in?' do
    
    it 'should return true if checked_in is set' do
      @reservation = FactoryGirl.create(:checkin)
      expect(@reservation.checked_in?).to eq(true)
    end

    it 'should return false if checked_in is not set' do
      @reservation = FactoryGirl.create(:checkout)
      expect(@reservation.checked_in?).to eq(false)
    end
  end

end
