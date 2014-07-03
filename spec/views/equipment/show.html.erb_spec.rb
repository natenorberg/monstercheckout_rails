require 'rails_helper'

RSpec.describe "equipment/show", :type => :view do
  before(:each) do
    @equipment = assign(:equipment, Equipment.create!(
      :name => "Name",
      :brand => "Brand",
      :quantity => 1,
      :condition => "Condition"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Brand/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Condition/)
  end
end
