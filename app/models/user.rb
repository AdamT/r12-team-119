require 'digest/md5'
require 'securerandom'
class User < ActiveRecord::Base
  before_create :assign_token
  validates_uniqueness_of :email
  validates_presence_of :email
  validates_format_of :email, with: /^.+@.+\..+$/

  has_many :own_groups, class_name: "Group"
  has_many :responses, class_name: "GroupParticipant"
  has_many :groups, through: :responses

  def display_name
    if name.blank?
      "New user"
    else
      name
    end
  end
  def ready?
    self.confirmed
  end

  def assign_token
    self.assign_new_login_token
    self.token = SecureRandom.base64(24)
  end

  def assign_new_login_token
    self.login_token = SecureRandom.hex(16)
  end

  def email=(e)
    super(e.downcase)
  end

  def gravatar(size = 80)
    "//www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}?s=#{size}"
  end

  def self.confirm_login(token)
    user = find_by_login_token(token)
    if user
      user.assign_new_login_token
      user.confirmed = true
      user.save
    end
    user
  end

end
