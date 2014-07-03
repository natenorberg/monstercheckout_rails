class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :project
      t.datetime :in_time
      t.datetime :out_time
      t.datetime :checked_out_time
      t.datetime :checked_in_time
      t.boolean :is_approved
      t.text :check_out_comments
      t.text :check_in_comments

      t.timestamps
    end
  end
end
