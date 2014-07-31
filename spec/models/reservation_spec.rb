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
#

require 'rails_helper'

RSpec.describe Reservation, :type => :model do

  before { @reservation = FactoryGirl.create(:reservation) }

  it "should respond to attributes" do
    expect(@reservation).to respond_to(:project)
    expect(@reservation).to respond_to(:out_time)
    expect(@reservation).to respond_to(:in_time)
    expect(@reservation).to respond_to(:checked_out_time)
    expect(@reservation).to respond_to(:checked_in_time)
    expect(@reservation).to respond_to(:is_approved?)
    expect(@reservation).to respond_to(:check_out_comments)
    expect(@reservation).to respond_to(:check_in_comments)
  end

  it "should have a valid factory" do
    expect(@reservation).to be_valid
  end

  it "should be invalid without a project" do
    @reservation.project = ''
    expect(@reservation).to_not be_valid
  end

  it "should be invalid without out_time" do
    @reservation.out_time = nil
    expect(@reservation).to_not be_valid
  end

  it "should be invalid without in_time" do
    @reservation.in_time = nil
    expect(@reservation).to_not be_valid
  end

end
