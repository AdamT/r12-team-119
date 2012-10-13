require 'digest/md5'
require 'securerandom'
class User < ActiveRecord::Base
  before_create :assign_token
  validates_uniqueness_of :email
  def assign_token
    self.assign_new_login_token
    self.token = SecureRandom.base64(24)
  end

  def assign_new_login_token
    self.login_token = SecureRandom.hex(16)
  end

  def gravatar
    "//www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
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
