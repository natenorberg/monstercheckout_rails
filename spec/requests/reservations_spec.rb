require 'rails_helper'

RSpec.describe "Reservations", :type => :request do
  describe "GET /reservations" do
    it "works! (now write some real specs)" do
      get reservations_path
      expect(response.status).to be(200)
    end
  end
end
