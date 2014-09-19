require 'rails_helper'

RSpec.describe StaticPagesController, :type => :routing do
  describe 'routing' do

    it 'routes to #home' do
      expect(:get => '/').to route_to('static_pages#home')
      expect(:get => '/home').to route_to('static_pages#home')
    end

    it 'routes to #welcome' do
      expect(:get => '/welcome').to route_to('static_pages#welcome')
    end

    it 'routes to #about' do
      expect(:get => '/about').to route_to('static_pages#about')
    end

    it 'routes to #help' do
      expect(:get => '/help').to route_to('static_pages#help')
    end

  end
end