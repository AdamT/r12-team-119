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
  def owned_by?(user)
    return false unless user
    user.id == user_id
  end
  def ready?
    !(title.blank? || user_id.blank?)
  end

  def fill_timecard_with(params)
    timecard.fill_with(params)
    self.serialized_timecard = timecard.serialize
  end
  def timecard
    return @timecard if @timecard
    @timecard = Timecard.new
    @timecard.deserialize(serialized_timecard) if self.serialized_timecard
    @timecard
  end
  def timecard=(card)
    self.serialized_timecard = card.serialize
    @timecard = card
  end
end
