# == Schema Information
#
# Table name: reservation_equipment
#
#  id             :integer          not null, primary key
#  reservation_id :integer
#  equipment_id   :integer
#  quantity       :integer
#

require 'rails_helper'

RSpec.describe ReservationEquipment, :type => :model do

  before do
    equipment = FactoryGirl.create(:equipment)
    reservation = FactoryGirl.create(:reservation)
    @association = ReservationEquipment.create!({ equipment_id: equipment.id,
                                                  reservation_id: reservation.id,
                                                  quantity: 2})
  end

  it "should respond to attributes" do
    expect(@association).to respond_to(:reservation_id)
    expect(@association).to respond_to(:equipment_id)
    expect(@association).to respond_to(:quantity)
  end

  it "should have a valid factory" do
    expect(@association).to be_valid
  end

  it "should be invalid without a reservation_id" do
    @association.reservation_id = nil
    expect(@association).to_not be_valid
  end

  it "should be invlaid without an equipment_id" do
    @association.equipment_id = nil
    expect(@association).to_not be_valid
  end

  it "should be invalid without a quantity" do
    @association.quantity = nil
    expect(@association).to_not be_valid
  end

  it "should be invalid if quantity is not greater than 0" do
    @association.quantity = 0
    expect(@association).to_not be_valid
  end

  it "should be invalid if quantity is not an integer" do
    @association.quantity = 1.7
    expect(@association).to_not be_valid
  end
end
