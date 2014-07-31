# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  remember_token  :string(255)
#  is_admin        :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  has_secure_password
  has_many :reservations
  has_many :monitor_checkouts, foreign_key: 'checked_out_by_id', class_name: 'Reservation'
  has_many :monitor_checkins, foreign_key: 'checked_in_by_id', class_name: 'Reservation'

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX } ,
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
