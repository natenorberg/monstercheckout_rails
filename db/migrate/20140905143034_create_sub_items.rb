class CreateSubItems < ActiveRecord::Migration
  def change
    create_table :sub_items do |t|
      t.string :name
      t.string :brand
      t.integer :kit_id
      t.text :description
      t.boolean :is_optional

      t.timestamps
    end

    add_index :sub_items, :kit_id
  end
end
