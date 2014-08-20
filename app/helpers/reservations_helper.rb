module ReservationsHelper

  def status_text(reservation)
    case reservation.status
    when 'requested'
      icon = 'asterisk'
      status_message = 'Waiting for approval'
    when 'approved'
      icon = 'thumbs-o-up'
      status_message = 'Approved'
    when 'denied'
      icon = 'thumbs-o-down'
      status_message = 'Denied'
    when 'out'
      icon = 'sign-out'
      status_message = 'Checked out'
    when 'overdue'
      icon = 'warning'
      status_message = 'Overdue'
    when 'returned'
      icon = 'check-circle'
      status_message = 'Returned'
    when 'returned_late'
      icon = 'meh-o'
      status_message = 'Returned late'
    when 'forgotten'
      icon = 'question'
      status_message = 'Forgotten'
    end

    return "<span class=\"status-text-#{reservation.status}\"><i class=\"fa fa-#{icon}\"></i> #{status_message}</span>"
  end

  def setup_reservation_form(reservation)

    (Equipment.all - reservation.equipment).each do |equipment|
      reservation.reservation_equipment.build(equipment: equipment)
    end

    # reservation.reservation_equipment.sort_by { |x| x.equipment.name }
  end
end
