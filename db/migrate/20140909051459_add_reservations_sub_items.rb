class AddReservationsSubItems < ActiveRecord::Migration
  def change
    create_table :reservations_sub_items, :id => false do |t|
      t.integer :reservation_id
      t.integer :sub_item_id
    end

    add_index :reservations_sub_items, [:reservation_id, :sub_item_id]
  end
end
