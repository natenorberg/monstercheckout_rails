require 'rails_helper'

RSpec.describe 'permissions/new', :type => :view do
  before do 
    assign(:permission, Permission.new(
      :name => 'name',
      :description => 'description'
    ))
  end

  it 'renders new permission form' do
    render

    assert_select 'form[action=?][method=?]', permissions_path, 'post' do
      
      assert_select 'input#permission_name[name=?]', 'permission[name]'

      assert_select 'textarea#permission_description[name=?]', 'permission[description]'

      assert_select 'input[name=?]', 'permission[user_ids][]'

      assert_select 'input[name=?]', 'permission[equipment_ids][]'
    end
  end

  it 'renders breadcrumbs' do
    render

    verify_breadcrumbs ['Permissions', 'New']
  end
end