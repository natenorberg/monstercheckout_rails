class AddApprovalTimestampToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :is_denied, :boolean
    add_column :reservations, :admin_response_time, :datetime
  end
end
