class AddCategoryIdToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :category_id, :integer

    add_index :equipment, :category_id
  end
end
