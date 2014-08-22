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

  def get_previous_quantity(reservation_id, equipment_id)
    association = ReservationEquipment.where(:reservation_id => reservation_id, :equipment_id => equipment_id).first
    if association != nil
      association.quantity
    else
      return 1
    end
  end

  INDEX_DATETIME_FORMAT = '%a, %m/%d/%y, %I:%M %p'
end
