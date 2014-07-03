require 'rails_helper'

RSpec.describe "reservations/index", :type => :view do
  before(:each) do
    assign(:reservations, [
      Reservation.create!(
        :project => "Project",
        :is_approved => false,
        :check_out_comments => "MyText",
        :check_in_comments => "MyText"
      ),
      Reservation.create!(
        :project => "Project",
        :is_approved => false,
        :check_out_comments => "MyText",
        :check_in_comments => "MyText"
      )
    ])
  end

  it "renders a list of reservations" do
    render
    assert_select "tr>td", :text => "Project".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
