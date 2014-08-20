# == Schema Information
#
# Table name: reservation_equipment
#
#  id             :integer          not null, primary key
#  reservation_id :integer
#  equipment_id   :integer
#  quantity       :integer
#

class ReservationEquipment < ActiveRecord::Base
  self.table_name = 'reservation_equipment' # Tries to default to reservation_equipments

  belongs_to :reservation, class_name: 'Reservation'
  belongs_to :equipment,   class_name: 'Equipment'

  validates :quantity, numericality: {only_integer: true, greater_than: 0}
  validate :quantity_should_be_less_than_total_quantity

  # Not raising presence validation errors here because it seems to have some issues with the reservation forms
  # This model has no controller so these relationships should only be created or updated from reservation_controller

  private

    def quantity_should_be_less_than_total_quantity
      errors.add(:in_time, "can't be more than the total quantity") if
          quantity > equipment.quantity
    end
end
