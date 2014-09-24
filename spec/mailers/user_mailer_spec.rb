require 'rails_helper'

describe UserMailer do
  describe 'need_approval_email' do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:reservation) { FactoryGirl.create(:reservation) }
    let(:mail) { UserMailer.need_approval_email(admin, reservation) }

    it 'renders the subject' do
      expect(mail.subject).to eq('A reservation needs your approval')
    end

    it 'renders the user email' do
      expect(mail.to).to eq([admin.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@montana.edu'])
    end

    # Putting render tests for mails in this fixture rather than traditional view testing
    it 'renders reservation info' do
      expect(mail.body.encoded).to match reservation.user.name
      expect(mail.body.encoded).to match reservation.project
      expect(mail.body.encoded).to match reservation.out_time.strftime(ReservationsHelper::LONG_DATETIME_FORMAT)
      expect(mail.body.encoded).to match reservation.in_time.strftime(ReservationsHelper::LONG_DATETIME_FORMAT)
    end

    it 'renders important links' do
      expect(mail.body.encoded).to have_link 'View this reservation online', href: 'http://localhost:3000/reservations/1'
      expect(mail.body.encoded).to have_link 'Approve', href: 'http://localhost:3000/reservations/1/approve'
      expect(mail.body.encoded).to have_link 'Deny', href: 'http://localhost:3000/reservations/1/deny'
    end
  end
end