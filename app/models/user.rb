# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  name                      :string(255)
#  email                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  password_digest           :string(255)
#  remember_token            :string(255)
#  is_admin                  :boolean          default(FALSE)
#  is_monitor                :boolean
#  notify_on_approval_needed :boolean          default(TRUE)
#  notify_on_approved        :boolean          default(TRUE)
#  notify_on_denied          :boolean          default(TRUE)
#  notify_on_checked_out     :boolean          default(TRUE)
#  notify_on_checked_in      :boolean          default(TRUE)
#

class User < ActiveRecord::Base
  has_secure_password
  has_many :reservations
  has_many :monitor_checkouts, foreign_key: 'checked_out_by_id', class_name: 'Reservation'
  has_many :monitor_checkins, foreign_key: 'checked_in_by_id', class_name: 'Reservation'
  has_and_belongs_to_many :permissions

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX } ,
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  # Mailing lists
  scope :approval_needed_mailing_list, -> { where(is_admin: true, notify_on_approval_needed: true) }

  def monitor_access?
    is_admin? || is_monitor?
  end

  def allowed_equipment
    ids = Set.new
    permissions.each do |p|
      p.equipment.each do |item|
        ids.add(item.id)
      end
    end

    Equipment.where(id: ids.to_a)
  end

  def first_name
    name.split(' ')[0]
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
