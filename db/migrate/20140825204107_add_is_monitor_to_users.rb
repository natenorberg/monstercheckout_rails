class AddIsMonitorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_monitor, :boolean
  end
end
