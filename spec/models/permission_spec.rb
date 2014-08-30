# == Schema Information
#
# Table name: permissions
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Permission, :type => :model do
  
  before { @permission = FactoryGirl.create(:permission)}

  it 'should respond to attributes' do
    expect(@permission).to respond_to(:name)
    expect(@permission).to respond_to(:description)
    expect(@permission).to respond_to(:users)
    expect(@permission).to respond_to(:equipment)
  end

  it 'should have a valid factory' do
    expect(@permission).to be_valid
  end

  it 'should be invalid without a name' do
    @permission.name = ''
    expect(@permission).to_not be_valid
  end

  it 'should be invalid with a duplicate name' do
    other_permission = @permission.dup
    expect(other_permission).to_not be_valid
  end

end
