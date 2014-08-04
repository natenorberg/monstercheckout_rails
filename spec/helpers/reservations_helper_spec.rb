require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ReservationsHelper. For example:
#
# describe ReservationsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ReservationsHelper, :type => :helper do

  describe "status_text" do
    before { @mock_reservation = stub_model(Reservation) }

    it "should format requested status" do
      @mock_reservation.stub(:status).and_return('requested')

      expect(helper.status_text(@mock_reservation)).to have_selector('span.status-text-requested')
      expect(helper.status_text(@mock_reservation)).to have_selector('i.fa.fa-asterisk')
      expect(helper.status_text(@mock_reservation)).to match('Waiting for approval')
    end

    it "should format approved status" do
      @mock_reservation.stub(:status).and_return('approved')

      expect(helper.status_text(@mock_reservation)).to have_selector('span.status-text-approved')
      expect(helper.status_text(@mock_reservation)).to have_selector('i.fa.fa-thumbs-o-up')
      expect(helper.status_text(@mock_reservation)).to match('Approved')
    end

    it "should format denied status" do
      @mock_reservation.stub(:status).and_return('denied')

      expect(helper.status_text(@mock_reservation)).to have_selector('span.status-text-denied')
      expect(helper.status_text(@mock_reservation)).to have_selector('i.fa.fa-thumbs-o-down')
      expect(helper.status_text(@mock_reservation)).to match('Denied')
    end

    it "should format out status" do
      @mock_reservation.stub(:status).and_return('out')

      expect(helper.status_text(@mock_reservation)).to have_selector('span.status-text-out')
      expect(helper.status_text(@mock_reservation)).to have_selector('i.fa.fa-sign-out')
      expect(helper.status_text(@mock_reservation)).to match('Checked out')
    end

    it "should format overdue status" do
      @mock_reservation.stub(:status).and_return('overdue')

      expect(helper.status_text(@mock_reservation)).to have_selector('span.status-text-overdue')
      expect(helper.status_text(@mock_reservation)).to have_selector('i.fa.fa-warning')
      expect(helper.status_text(@mock_reservation)).to match('Overdue')
    end

    it "should format returned status" do
      @mock_reservation.stub(:status).and_return('returned')

      expect(helper.status_text(@mock_reservation)).to have_selector('span.status-text-returned')
      expect(helper.status_text(@mock_reservation)).to have_selector('i.fa.fa-check-circle')
      expect(helper.status_text(@mock_reservation)).to match('Returned')
    end

    it "should format returned_late status" do
      @mock_reservation.stub(:status).and_return('returned_late')

      expect(helper.status_text(@mock_reservation)).to have_selector('span.status-text-returned_late')
      expect(helper.status_text(@mock_reservation)).to have_selector('i.fa.fa-meh-o')
      expect(helper.status_text(@mock_reservation)).to match('Returned late')
    end

    it "should format forgotten status" do
      @mock_reservation.stub(:status).and_return('forgotten')

      expect(helper.status_text(@mock_reservation)).to have_selector('span.status-text-forgotten')
      expect(helper.status_text(@mock_reservation)).to have_selector('i.fa.fa-question')
      expect(helper.status_text(@mock_reservation)).to match('Forgotten')
    end
  end
end
