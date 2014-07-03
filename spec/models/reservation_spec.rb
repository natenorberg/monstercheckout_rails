# == Schema Information
#
# Table name: reservations
#
#  id                 :integer          not null, primary key
#  project            :string(255)
#  in_time            :datetime
#  out_time           :datetime
#  checked_out_time   :datetime
#  checked_in_time    :datetime
#  is_approved        :boolean
#  check_out_comments :text
#  check_in_comments  :text
#  created_at         :datetime
#  updated_at         :datetime
#

require 'rails_helper'

RSpec.describe Reservation, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
