class AddReferencesToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :user_id, :integer
    add_column :reservations, :checked_out_by_id, :integer
    add_column :reservations, :checked_in_by_id, :integer

    add_index :reservations, :user_id
  end
end
