class AddDescriptionToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :description, :string
  end
end
