class UserMailer < ActionMailer::Base
  default from: "noreply@montana.edu"

  def need_approval_email(admin, reservation)
    @admin = admin
    @reservation = reservation
    @url = reservation_path(reservation)
    mail(to: @admin.email, subject: 'A reservation needs your approval')
  end
end
