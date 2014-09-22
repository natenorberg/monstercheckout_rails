class UserMailer < ActionMailer::Base
  default from: "noreply@montana.edu"

  def need_approval_email(reservation)
    @reservation = reservation
    @url = reservation_path(reservation)

    recipients = User.approval_needed_mailing_list
    recipients.each do |admin|
      mail(to: @admin.email, subject: 'A reservation needs your approval')
    end
  end
end
