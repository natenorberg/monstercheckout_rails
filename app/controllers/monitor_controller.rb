class MonitorController < ApplicationController
  before_filter :user_signed_in
  before_filter :user_is_monitor

  def dashboard
    @checkouts = Reservation.where(checked_out_time: nil).where(is_approved: true)
    @checkins = Reservation.checked_out
  end
end
