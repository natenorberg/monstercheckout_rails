class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.string :name
      t.string :brand
      t.integer :quantity
      t.string :condition

      t.timestamps
    end
  end
end
