require 'rails_helper'

RSpec.describe 'permissions/show', :type => :view do
  before do 
    @permission = assign(:permission, Permission.create!(
      :name => 'name',
      :description => 'description'
    ))
  end

  it 'renders permission info' do
    render

    expect(rendered).to match /name/
    expect(rendered).to match /description/
  end

  it 'renders breadcrumbs' do
    render

    verify_breadcrumbs ['Permissions', @permission.name]
  end
end