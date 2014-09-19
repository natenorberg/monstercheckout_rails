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

  describe 'is_monitor_action?' do
    
    it 'should be true if controller is monitor' do
      expect(helper.is_monitor_action?('monitor', 'anything')).to eq(true)
    end

    it 'should be true for checkout and checkin' do
      expect(helper.is_monitor_action?('reservations', 'checkout')).to eq(true)
      expect(helper.is_monitor_action?('reservations', 'checkin')).to eq(true)
    end
  end

  describe 'is_admin_action?' do
    
    it 'should be true if controller is admin' do
      expect(helper.is_admin_action?('admin', 'anything')).to eq(true)
    end

    it 'should be true if controller is users' do
      expect(helper.is_admin_action?('users', 'anything')).to eq(true)
    end

    it 'should be true if controller is permissions' do
      expect(helper.is_admin_action?('permissions', 'anything')).to eq(true)
    end

  end
end