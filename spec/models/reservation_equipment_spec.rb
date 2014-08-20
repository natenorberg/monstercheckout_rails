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
    @association = FactoryGirl.create(:reservation_equipment)
  end

  it 'should respond to attributes' do
    expect(@association).to respond_to(:reservation_id)
    expect(@association).to respond_to(:equipment_id)
    expect(@association).to respond_to(:quantity)
  end

  it 'should have a valid factory' do
    expect(@association).to be_valid
  end

  it 'should be invalid when quantity is less than 1' do
    @association.quantity = 0
    expect(@association).to_not be_valid
  end

  it 'should be invalid when quantity is greater than equipment quantity' do
    @association.quantity = @association.equipment.quantity+1
    expect(@association).to_not be_valid
  end

  it 'should be invalid when quantity is not an integer' do
    @association.quantity = 1.7
    expect(@association).to_not be_valid
  end

end
