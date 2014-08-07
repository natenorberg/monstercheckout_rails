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

  validates :reservation_id, presence: true
  validates :equipment_id, presence: true
  # Throwing errors with checkboxes; temporarily removing validation
  # validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0}
end
