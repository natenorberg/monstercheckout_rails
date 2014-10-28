require 'rails_helper'

RSpec.describe SearchController, :type => :controller do
  describe 'routing' do

    it 'routes to #index' do
      expect(:get => '/search').to route_to('search#index')
    end
  end
end
