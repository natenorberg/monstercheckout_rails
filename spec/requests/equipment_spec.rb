require 'rails_helper'

RSpec.describe "Equipment", :type => :request do
  describe "GET /equipment" do
    it "works! (now write some real specs)" do
      get equipment_index_path
      expect(response.status).to be(200)
    end
  end
end
