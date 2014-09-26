require 'rails_helper'

describe UserMailer do
  describe 'welcome_email' do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.welcome_email(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq('Welcome to MONSTER Checkout')
    end

    it 'renders the user email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@montana.edu'])
    end
  end

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

  shared_examples_for 'user reservation update emails' do
    it 'renders the user email' do
      expect(mail.to).to eq([reservation.user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@montana.edu'])
    end
  end

  describe 'approved_email' do
    let(:reservation) { FactoryGirl.create(:approved_reservation) }
    let(:mail) { UserMailer.approved_email(reservation) }

    it_should_behave_like 'user reservation update emails'

    it 'renders the subject' do
      expect(mail.subject).to eq('Your reservation has been approved')
    end

    it 'renders reservation info' do
      expect(mail.body.encoded).to match reservation.user.first_name
      expect(mail.body.encoded).to match reservation.project
      expect(mail.body.encoded).to match reservation.out_time.strftime(ReservationsHelper::LONG_DATETIME_FORMAT)
      expect(mail.body.encoded).to have_link 'View Reservation', href: 'http://localhost:3000/reservations/1'
    end
  end

  describe 'denied_email' do
    let(:reservation) { FactoryGirl.create(:reservation) }
    let(:mail) { UserMailer.denied_email(reservation) }

    it_should_behave_like 'user reservation update emails'

    it 'renders the subject' do
      expect(mail.subject).to eq('Your reservation has been denied')
    end

    it 'renders reservation info' do
      expect(mail.body.encoded).to match reservation.user.first_name
      expect(mail.body.encoded).to match reservation.project
      expect(mail.body.encoded).to have_link 'View Reservation', href: 'http://localhost:3000/reservations/1'
    end

    describe 'checked_out_email' do
      let(:reservation) { FactoryGirl.create(:checkout) }
      let(:mail) { UserMailer.checked_out_email(reservation) }

      it_should_behave_like 'user reservation update emails'

      it 'renders the subject' do
        expect(mail.subject).to eq('Your reservation has been checked out')
      end

      it 'renders reservation info' do
        expect(mail.body.encoded).to match reservation.user.first_name
        expect(mail.body.encoded).to match reservation.project
        expect(mail.body.encoded).to match reservation.in_time.strftime(ReservationsHelper::LONG_DATETIME_FORMAT)
        expect(mail.body.encoded).to have_link 'View Reservation', href: 'http://localhost:3000/reservations/1'
      end
    end
  end
end