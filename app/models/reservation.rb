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

class Reservation < ActiveRecord::Base
  validates :project,  presence: true
  validates :out_time, presence: true
  validates :in_time,  presence: true
  validate  :in_time_must_be_after_out_time
  validates :check_out_comments, presence: true, if: '!checked_out_time.blank?'
  validates :check_in_comments,  presence: true, if: '!checked_in_time.blank?'
  validate  :checked_out_time_should_not_change
  validate  :checked_in_time_should_not_change
  validates :checked_in_time, absence: true, if: '!checked_out?'

  def checked_out?
    checked_out_time != nil
  end

  def checked_in?
    checked_in_time != nil
  end

  private

    def in_time_must_be_after_out_time
      errors.add(:in_time, "can't be before out time") if
        !in_time.blank? and !out_time.blank? and in_time < out_time
    end

    def checked_out_time_should_not_change
      errors.add(:checked_out_time, "can't be updated after set") if
        checked_out_time_changed? and checked_out_time_was != nil
    end

    def checked_in_time_should_not_change
      errors.add(:checked_in_time, "can't be updated after set") if
        checked_in_time_changed? and checked_in_time_was != nil
    end

end
