require 'rails_helper'

RSpec.describe 'sub_items/new', :type => :view do
  before do 
    @kit = FactoryGirl.create(:equipment)
    @sub_item = assign(:sub_item, SubItem.new(
      :kit_id => @kit.id,
      :name => 'name',
      :brand => 'brand',
      :description => 'description',
      :is_optional => false
    ))
  end 

  it 'renders the new sub_item form' do
    render template: 'sub_items/new'

    assert_select 'form[action=?][method=?]', equipment_sub_items_path(@kit), 'post' do
      
      assert_select 'input#sub_item_name[name=?]', 'sub_item[name]'

      assert_select 'input#sub_item_brand[name=?]', 'sub_item[brand]'

      assert_select 'textarea#sub_item_description[name=?]', 'sub_item[description]'

      assert_select 'input#sub_item_is_optional[name=?]', 'sub_item[is_optional]'
    end
  end

  it 'renders breadcrumbs' do
    render

    verify_breadcrumbs ['Equipment', @kit.name, 'New']
  end
end