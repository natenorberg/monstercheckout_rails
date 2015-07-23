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
#  is_kit      :boolean
#  type        :integer
#  category_id :integer
#

require 'rails_helper'

RSpec.describe Equipment, :type => :model do

  before { @equipment = FactoryGirl.create(:equipment) }

  it 'should respond to attributes' do
    expect(@equipment).to respond_to(:name)
    expect(@equipment).to respond_to(:brand)
    expect(@equipment).to respond_to(:quantity)
    expect(@equipment).to respond_to(:condition)
    expect(@equipment).to respond_to(:description)
    expect(@equipment).to respond_to(:reservations)
    expect(@equipment).to respond_to(:permissions)
    expect(@equipment).to respond_to(:is_kit?)
    expect(@equipment).to respond_to(:sub_items)
    expect(@equipment).to respond_to(:category)
  end

  it 'should have a valid factory' do
    expect(@equipment).to be_valid
  end

  it 'is invalid without a name' do
    @equipment.name = ''
    expect(@equipment).to_not be_valid
  end

  it 'is invalid with quantity of zero' do
    @equipment.quantity = 0
    expect(@equipment).to_not be_valid
  end

  it 'is invalid with non-integer length' do
    @equipment.quantity = 1.5
    expect(@equipment).to_not be_valid
  end

  it 'is invalid without a condition' do
    @equipment.condition = ''
    expect(@equipment).to_not be_valid
  end

  it 'is invalid without a description' do
    @equipment.description = ''
    expect(@equipment).to_not be_valid
  end

  describe 'can_be_checked_out_by' do
    before do
      @user = stub_model(User)
    end

    describe 'when user has permission' do
      before do
        permission = FactoryGirl.create(:permission)
        @equipment.permissions = [permission]
        @user.stub(:permissions).and_return [permission]
      end

      it 'should return true' do
        expect(@equipment.can_be_checked_out_by(@user)).to eq(true)
      end
    end

    describe 'when user does not have permission' do
      before do
        permission = FactoryGirl.create(:permission)
        other_permission = FactoryGirl.create(:permission)

        @equipment.permissions = [permission]
        @user.stub(:permissions).and_return [other_permission]
      end

      it 'should return false' do
        expect(@equipment.can_be_checked_out_by(@user)).to eq(false)
      end
    end
  end

end
