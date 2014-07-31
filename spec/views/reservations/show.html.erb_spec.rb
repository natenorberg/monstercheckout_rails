require 'rails_helper'

RSpec.describe "reservations/show", :type => :view do
  before(:each) do
    @reservation = assign(:reservation, Reservation.create!(
      :project => "Project",
      :out_time => 1.days.ago,
      :in_time => 1.days.from_now,
      :is_approved => false,
      :check_out_comments => "MyText",
      :check_in_comments => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Project/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
