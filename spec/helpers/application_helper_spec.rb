require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  
  describe 'full_title' do
    
    it 'should be correct without page title' do
      expect(helper.full_title('')).to eq('MONSTER Checkout')
    end

    it 'should format page title into title' do
      expect(helper.full_title('Hello')).to eq('MONSTER Checkout | Hello')
    end
  end

  describe 'bootstrap flash classnames' do
    
    it 'should render success correctly' do
      expect(helper.bootstrap_class_for('success')).to eq('alert-success')
    end

    it 'should render success correctly' do
      expect(helper.bootstrap_class_for('notice')).to eq('alert-warning')
    end

    it 'should render success correctly' do
      expect(helper.bootstrap_class_for('error')).to eq('alert-danger')
    end

    it 'should render success correctly' do
      expect(helper.bootstrap_class_for('marshmallow')).to eq('marshmallow')
    end
  end
end