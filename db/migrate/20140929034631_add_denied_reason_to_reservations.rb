class AddDeniedReasonToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :denied_reason, :string
  end
end
