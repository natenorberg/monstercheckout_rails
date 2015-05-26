module ConflictChecker

  # TODO: Get tests around this
  # TODO: Complex method
  def conflicts(params)
    # Get the other reservations to check agains
    # TODO: Be more selective here
    if params[:id]
      other_reservations = Reservation.where.not(id: params[:id])
    else
      other_reservations = Reservation.all
    end

    overlapping_reservations = []
    other_reservations.each do |reservation|
      if overlap(reservation, params[:reservation][:out_time], params[:reservation][:in_time])
        overlapping_reservations << reservation
      end
    end

    conflicting_equipment(params[:reservation][:equipment_ids], params[:reservation][:quantity], overlapping_reservations)
  end

  def overlap(reservation, start_time, end_time)
    if start_time < reservation.out_time
      # New reservation starts before other one
      if end_time < reservation.in_time
        return false # Other reservation returned before new one checked out
      else
        return true
      end

    else
      if start_time > reservation.in_time
        return false # Reservation is returned before requested out_time
      else
        return true
      end
    end
  end

  # TODO: Complex method
  def conflicting_equipment(equipment_ids, quantities, other_reservations)
    equipment = Equipment.where(:id => equipment_ids)
    conflicts = {}
    total_quantities = {}

    equipment.each do |item|
      # Start with the total number of each item and substract the quantities from the reservations
      # that overlap. If this goes below 0, then there's a conflict
      total_quantities[item.id] = item.quantity - quantities[item.id.to_s].to_i
    end

    # Triple nested loops are bad, but they can't be very deep in this scenario and I'm not sure there's another way
    other_reservations.each do |reservation|
      reservation.reservation_equipment.each do |other_item|
        equipment.each do |item|

          if item == other_item.equipment
            total_quantities[item.id] -= other_item.quantity

            if total_quantities[item.id] < 0
              conflicts[item.name] = reservation
            end
          end

        end
      end
    end

    conflicts
  end
end
