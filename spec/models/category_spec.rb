# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Category, :type => :model do

  before { @category = FactoryGirl.create(:category) }

  it 'should respond to attributes' do
    expect(@category).to respond_to(:name)
    expect(@category).to respond_to(:description)
    expect(@category).to respond_to(:equipment)
  end

  it 'should have a valid factory' do
    expect(@category).to be_valid
  end

  it 'is invalid without a name' do
    @category.name = ''
    expect(@category).to_not be_valid
  end

  it 'is invalid with a non-unique name' do
    @category.save
    other_category = @category.dup
    expect(other_category).to_not be_valid
  end
end
