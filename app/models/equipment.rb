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
#

class Equipment < ActiveRecord::Base
  validates :name, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :condition, presence: true
  validates :description, presence: true
end
