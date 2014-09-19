class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :equipment_permissions, :id => false do |t|
      t.integer 'equipment_id'
      t.integer 'permission_id'
    end

    create_table :permissions_users, :id => false do |t|
      t.integer 'permission_id'
      t.integer 'user_id'
    end

    add_index :equipment_permissions, ['equipment_id', 'permission_id']
    add_index :permissions_users, ['permission_id', 'user_id']
  end
end
