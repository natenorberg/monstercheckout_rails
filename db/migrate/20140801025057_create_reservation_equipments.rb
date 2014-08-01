class CreateReservationEquipments < ActiveRecord::Migration
  def change
    create_table :reservation_equipment do |t|
      t.integer :reservation_id
      t.integer :equipment_id
      t.integer :quantity
      # Don't need timestamps
    end

    add_index :reservation_equipment, :reservation_id
    add_index :reservation_equipment, :equipment_id
    add_index :reservation_equipment, [:reservation_id, :equipment_id], unique: true
  end
end
