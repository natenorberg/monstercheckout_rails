class UserMailer < ActionMailer::Base
  default from: "noreply@montana.edu"

  def need_approval_email(user, reservation)
    @reservation = reservation

    mail(to: user.email, subject: 'A reservation needs your approval')
  end
end