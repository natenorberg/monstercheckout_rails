require 'rails_helper'

RSpec.describe 'equipment/edit', :type => :view do
  before(:each) do
    @equipment = assign(:equipment, Equipment.create!(
      :name => 'MyString',
      :brand => 'MyString',
      :quantity => 1,
      :condition => 'MyString',
      :description => 'MyString'
    ))
  end

  it 'renders the edit equipment form' do
    render

    assert_select 'form[action=?][method=?]', equipment_path(@equipment), 'post' do

      assert_select 'input#equipment_name[name=?]', 'equipment[name]'

      assert_select 'input#equipment_brand[name=?]', 'equipment[brand]'

      assert_select 'input#equipment_quantity[name=?]', 'equipment[quantity]'

      assert_select 'input#equipment_condition[name=?]', 'equipment[condition]'

      assert_select 'input[name=?]', 'equipment[permission_ids][]'

      assert_select 'textarea#equipment_description[name=?]', 'equipment[description]' 

      assert_select 'input#equipment_is_kit[name=?]', 'equipment[is_kit]'

    end
  end

  it 'renders breadcrumbs' do
    render

    verify_breadcrumbs ['Equipment', @equipment.name, 'Edit']
  end
end
