# == Schema Information
#
# Table name: equipment
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  brand      :string(255)
#  quantity   :integer
#  condition  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Equipment < ActiveRecord::Base
end
