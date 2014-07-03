require 'rails_helper'

RSpec.describe "equipment/new", :type => :view do
  before(:each) do
    assign(:equipment, Equipment.new(
      :name => "MyString",
      :brand => "MyString",
      :quantity => 1,
      :condition => "MyString"
    ))
  end

  it "renders new equipment form" do
    render

    assert_select "form[action=?][method=?]", equipment_index_path, "post" do

      assert_select "input#equipment_name[name=?]", "equipment[name]"

      assert_select "input#equipment_brand[name=?]", "equipment[brand]"

      assert_select "input#equipment_quantity[name=?]", "equipment[quantity]"

      assert_select "input#equipment_condition[name=?]", "equipment[condition]"
    end
  end
end
