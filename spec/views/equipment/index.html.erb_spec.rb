require 'rails_helper'

RSpec.describe "equipment/index", :type => :view do
  before(:each) do
    assign(:equipment, [
      Equipment.create!(
        :name => "Name",
        :brand => "Brand",
        :quantity => 1,
        :condition => "Condition"
      ),
      Equipment.create!(
        :name => "Name",
        :brand => "Brand",
        :quantity => 1,
        :condition => "Condition"
      )
    ])
  end

  it "renders a list of equipment" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Brand".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Condition".to_s, :count => 2
  end
end
