require 'rails_helper'

RSpec.describe EquipmentController, :type => :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(:get => '/equipment').to route_to('equipment#index')
    end

    it 'routes to #new' do
      expect(:get => '/equipment/new').to route_to('equipment#new')
    end

    it 'routes to #show' do
      expect(:get => '/equipment/1').to route_to('equipment#show', :id => "1")
    end

    it 'routes to #edit' do
      expect(:get => '/equipment/1/edit').to route_to('equipment#edit', :id => "1")
    end

    it 'routes to #create' do
      expect(:post => '/equipment').to route_to('equipment#create')
    end

    it 'routes to #update' do
      expect(:put => '/equipment/1').to route_to('equipment#update', :id => "1")
    end

    it 'routes to #destroy' do
      expect(:delete => '/equipment/1').to route_to('equipment#destroy', :id => "1")
    end

    # SubItem routing
    it 'routes to sub_items#index' do
      expect(:get => '/equipment/1/sub_items').to route_to('sub_items#index', :equipment_id => '1')
    end

    it 'routes to sub_items#new' do
      expect(:get => '/equipment/1/sub_items/new').to route_to('sub_items#new', :equipment_id => '1')
    end

    it 'routes to sub_items#show' do
      expect(:get => '/equipment/1/sub_items/2').to route_to('sub_items#show', :equipment_id => '1', :id => "2")
    end

    it 'routes to sub_items#edit' do
      expect(:get => '/equipment/1/sub_items/2/edit').to route_to('sub_items#edit', :equipment_id => '1', :id => "2")
    end

    it 'routes to sub_items#create' do
      expect(:post => '/equipment/1/sub_items').to route_to('sub_items#create', :equipment_id => '1')
    end

    it 'routes to sub_items#update' do
      expect(:put => '/equipment/1/sub_items/2').to route_to('sub_items#update', :equipment_id => '1', :id => "2")
    end

    it 'routes to sub_items#destroy' do
      expect(:delete => '/equipment/1/sub_items/2').to route_to('sub_items#destroy', :equipment_id => '1', :id => "2")
    end
  end
end
