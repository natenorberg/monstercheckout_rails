# == Schema Information
#
# Table name: equipment
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  brand       :string(255)
#  quantity    :integer
#  condition   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#

require 'rails_helper'

RSpec.describe Equipment, :type => :model do
  
  before { @mic = FactoryGirl.create(:equipment) }

  it 'should respond to attributes' do
    expect(@mic).to respond_to(:name)
    expect(@mic).to respond_to(:brand)
    expect(@mic).to respond_to(:quantity)
    expect(@mic).to respond_to(:condition)
    expect(@mic).to respond_to(:description)
    expect(@mic).to respond_to(:reservations)
    expect(@mic).to respond_to(:permissions)
  end

  it 'should have a valid factory' do
    expect(@mic).to be_valid
  end

  it 'is invalid without a name' do
    @mic.name = ''
    expect(@mic).to_not be_valid
  end

  it 'is invalid with quantity of zero' do
    @mic.quantity = 0
    expect(@mic).to_not be_valid
  end

  it 'is invalid with non-integer length' do
    @mic.quantity = 1.5
    expect(@mic).to_not be_valid
  end

  it 'is invalid without a condition' do
    @mic.condition = ''
    expect(@mic).to_not be_valid
  end

  it 'is invalid without a description' do
    @mic.description = ''
    expect(@mic).to_not be_valid
  end

end
