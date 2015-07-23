require 'rails_helper'

RSpec.describe "categories/edit", :type => :view do
  before(:each) do
    @category = assign(:category, Category.create!(
      :name => 'Mic',
      :description => 'Description'
    ))
  end

  it "renders the edit category form" do
    render

    assert_select "form[action=?][method=?]", category_path(@category), "post" do
    end
  end

  it 'renders breadcrumbs' do
    render

    verify_breadcrumbs ['Equipment', 'Categories', @category.name, 'Edit']
  end
end
