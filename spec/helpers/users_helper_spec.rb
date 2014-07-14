require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, :type => :helper do

  describe "gravatar" do
    let(:user) { FactoryGirl.create(:user) }
    let(:gravatar_id) { Digest::MD5::hexdigest(user.email.downcase) }

    describe "with no size parameter" do
      it "creates the gravatar image url" do
        # Needs the 'amp;' in there because of image_tag's rendering
        expect(helper.gravatar_for(user)).to eq("<img alt=\"#{user.name}\" class=\"gravatar\" src=\"https://secure.gravatar.com/avatar/#{gravatar_id}?size=80\&amp;d=monsterid\" />")
      end
    end
    
    describe "with a size parameter" do
      it "creates the gravatar image url" do
        expect(helper.gravatar_for(user, 50)).to eq("<img alt=\"#{user.name}\" class=\"gravatar\" src=\"https://secure.gravatar.com/avatar/#{gravatar_id}?size=50\&amp;d=monsterid\" />")
      end
    end
  end
end
