require 'securerandom'
class User < ActiveRecord::Base
  before_create :assign_token
  validates_uniqueness_of :email
  def assign_token
    self.token = SecureRandom.base64
  end

end
