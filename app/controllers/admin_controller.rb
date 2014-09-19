class AdminController < ApplicationController
  before_filter :user_signed_in
  before_filter :user_is_admin

  def dashboard
    @permissions = Permission.all
    @reservations_pending = Reservation.where(status: 'requested')
  end
end
