class UserMailer < ActionMailer::Base
  default from: "noreply@montana.edu"
  layout 'email'

  def need_approval_email(user, reservation)
    @reservation = reservation
    @show_button_bar = true

    mail(to: user.email, subject: 'A reservation needs your approval')
  end
end