class AddIsKitToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :is_kit, :boolean
  end
end
