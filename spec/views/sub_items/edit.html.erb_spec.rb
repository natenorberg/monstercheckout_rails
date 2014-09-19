require 'rails_helper'

RSpec.describe 'sub_items/edit', :type => :view do
  before do 
    @kit = FactoryGirl.create(:equipment)
    @sub_item = assign(:sub_item, SubItem.create!(
      :kit_id => @kit.id,
      :name => 'name',
      :brand => 'brand',
      :description => 'description',
      :is_optional => false
    ))
  end 

  it 'renders the edit sub_item form' do
    render

    assert_select 'form[action=?][method=?]', equipment_sub_item_path(@kit, @sub_item), 'post' do
      
      assert_select 'input#sub_item_name[name=?]', 'sub_item[name]'

      assert_select 'input#sub_item_brand[name=?]', 'sub_item[brand]'

      assert_select 'textarea#sub_item_description[name=?]', 'sub_item[description]'

      assert_select 'input#sub_item_is_optional[name=?]', 'sub_item[is_optional]'
    end
  end

  it 'renders breadcrumbs' do
    render

    verify_breadcrumbs ['Equipment', @kit.name, @sub_item.name, 'Edit']
  end
end