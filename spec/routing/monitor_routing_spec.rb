require 'rails_helper'

RSpec.describe MonitorController, :type => :routing do
  describe 'routing' do
    
    it 'routes to #dashboard' do
      expect(:get => '/monitor/dashboard').to route_to('monitor#dashboard')
      expect(:get => '/monitor/').to route_to('monitor#dashboard')
    end

  end
end