require 'rails_helper'

RSpec.describe "categories/index", :type => :view do
  before(:each) do
    assign(:categories, [
      Category.create!(name: 'Mic 1', description: 'Description'),
      Category.create!(name: 'Mic 2', description: 'Description')
    ])
  end

  it "renders a list of categories" do
    render
  end
end
