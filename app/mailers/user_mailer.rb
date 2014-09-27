class UserMailer < ActionMailer::Base
  default from: "noreply@montana.edu"
  layout 'email'

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to MONSTER Checkout')
  end

  def need_approval_email(user, reservation)
    @reservation = reservation
    @show_button_bar = true

    mail(to: user.email, subject: 'A reservation needs your approval')
  end

  def approved_email(reservation)
    @reservation = reservation
    @show_button_bar = true
    mail(to: reservation.user.email, subject: 'Your reservation has been approved')
  end

  def denied_email(reservation)
    @reservation = reservation
    @show_button_bar = true
    mail(to: reservation.user.email, subject: 'Your reservation has been denied')
  end

  def checked_out_email(reservation)
    @reservation = reservation
    @show_button_bar = true
    mail(to: reservation.user.email, subject: 'Your reservation has been checked out')
  end

  def returned_email(reservation)
    @reservation = reservation
    @show_button_bar = true
    mail(to: reservation.user.email, subject: 'Your reservation has been returned')
  end
end