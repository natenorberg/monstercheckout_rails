require 'rails_helper'

RSpec.describe "equipment/show", :type => :view do
  before(:each) do
    mock_user = stub_model(User)
    mock_user.stub(:is_admin?).and_return(true)
    view.stub(:current_user).and_return(mock_user)
    @equipment = assign(:equipment, Equipment.create!(
      :name => "Name",
      :brand => "Brand",
      :quantity => 1,
      :condition => "Condition_",
      :description => "Description_"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Brand/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Condition_/)
    expect(rendered).to match(/Description_/)
  end
end
