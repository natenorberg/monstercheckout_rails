class AddDefaultNotificationSettings < ActiveRecord::Migration
  def change
    change_column_default :users, :notify_on_approval_needed, true
    change_column_default :users, :notify_on_approved, true
    change_column_default :users, :notify_on_denied, true
    change_column_default :users, :notify_on_checked_out, true
    change_column_default :users, :notify_on_checked_in, true
  end
end
