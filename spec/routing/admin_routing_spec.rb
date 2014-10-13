require 'rails_helper'

RSpec.describe AdminController, :type => :controller do
  describe 'routing' do

    it 'routes to #dashboard' do
      expect(:get => '/admin/dashboard').to route_to('admin#dashboard')
      expect(:get => '/admin').to route_to('admin#dashboard')
    end
  end
end
