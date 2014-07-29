require 'rails_helper'

RSpec.describe "equipment/index", :type => :view do
  before(:each) do
    @user = stub_model(User)
    @user.stub(:is_admin?).and_return(true)
    view.stub(:current_user).and_return(@user)
    assign(:equipment, [
      Equipment.create!(
        :name => "Name",
        :brand => "Brand",
        :quantity => 1,
        :condition => "Condition",
        :description => "A sample piece of equipment"
      ),
      Equipment.create!(
        :name => "Name",
        :brand => "Brand",
        :quantity => 1,
        :condition => "Condition",
        :description => "A sample piece of equipment"
      )
    ])
  end

  it "renders a list of equipment" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Brand".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
