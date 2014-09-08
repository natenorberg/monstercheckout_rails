require 'rails_helper'

RSpec.describe 'equipment/show', :type => :view do
  before(:each) do
    mock_user = stub_model(User)
    mock_user.stub(:is_admin?).and_return(true)
    view.stub(:current_user).and_return(mock_user)
    @permission = FactoryGirl.create(:permission)
    @equipment = assign(:equipment, Equipment.create!(
      :name => 'Name',
      :brand => 'Brand',
      :quantity => 1,
      :condition => 'Condition_',
      :description => 'Description_',
      :permissions => [@permission]
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Brand/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Condition_/)
    expect(rendered).to match(/Description_/)
    expect(rendered).to match(/Permissions/)
    expect(rendered).to have_selector 'ul.permissions-list>li', :text => @permission.name
    expect(rendered).to render_template(:partial => 'shared/_user_reservation_list')
  end

  it 'renders breadcrumbs' do
    render

    verify_breadcrumbs ['Equipment', @equipment.name]
  end

  describe 'when equipment is kit' do
    before do 
      @equipment.is_kit = true
      SubItem.create(kit_id: @equipment.id, name: 'Item', description: 'An item')
      @equipment.save
    end

    it 'renders list of contents' do
      render

      expect(rendered).to have_selector 'h4', :text => 'Contents'
      expect(rendered).to have_selector 'ul.contents-list>li'
    end
  end
end
