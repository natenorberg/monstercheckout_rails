require 'rails_helper'

RSpec.describe "users/index", :type => :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :name => "Name",
        :email => "email@example.com",
        :password => "password1",
        :password_confirmation => "password1",
        :is_admin => true
      ),
      User.create!(
        :name => "Name",
        :email => "email2@example.com",
        :password => "password1",
        :password_confirmation => "password1"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td>div>h4", :text => "Name".to_s, :count => 2
    assert_select "i.fa.fa-rocket", :count => 1
    assert_select "tr>td>div>h5", :text => "email@example.com".to_s, :count => 1
    assert_select "tr>td>div>h5", :text => "email2@example.com".to_s, :count => 1
  end
end
