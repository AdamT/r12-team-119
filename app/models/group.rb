require 'securerandom'
class Group < ActiveRecord::Base
  attr_accessible :title, :user_id
  before_create :assign_slug
  validates_uniqueness_of :slug
  belongs_to :user
  has_many :group_participants
  has_many :users, through: :group_participants
  def assign_slug
    self.slug = SecureRandom.urlsafe_base64(12)
  end
  def to_param
    slug
  end
end
