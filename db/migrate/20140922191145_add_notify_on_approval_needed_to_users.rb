class AddNotifyOnApprovalNeededToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_on_approval_needed, :boolean
  end
end
