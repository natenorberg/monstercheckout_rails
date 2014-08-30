# == Schema Information
#
# Table name: permissions
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Permission < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :equipment

  validates :name, presence: true, uniqueness: true
end
