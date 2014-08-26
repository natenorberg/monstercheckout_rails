class MonitorController < ApplicationController

  def dashboard
    @checkouts = Reservation.where(checked_out_time: nil).where(is_approved: true)
    @checkins = Reservation.checked_out
  end
end
