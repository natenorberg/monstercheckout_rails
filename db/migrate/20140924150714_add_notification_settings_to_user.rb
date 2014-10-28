class AddNotificationSettingsToUser < ActiveRecord::Migration
  def change
    add_column :users, :notify_on_approved, :boolean
    add_column :users, :notify_on_denied, :boolean
    add_column :users, :notify_on_checked_out, :boolean
    add_column :users, :notify_on_checked_in, :boolean
  end
end
