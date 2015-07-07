# == Schema Information
#
# Table name: equipment
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  brand       :string(255)
#  quantity    :integer
#  condition   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#  is_kit      :boolean
#  type        :integer
#

class Equipment < ActiveRecord::Base
  has_many :reservation_equipment
  has_many :reservations, through: :reservation_equipment
  has_many :sub_items, :foreign_key => :kit_id, :class_name => 'SubItem'
  has_and_belongs_to_many :permissions

  validates :name, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :condition, presence: true
  validates :description, presence: true

  def can_be_checked_out_by(user)
    permissions.each do |permission|
      user.permissions.each do |user_permission|
        if permission == user_permission
          return true
        end
      end
    end

    false
  end
end
