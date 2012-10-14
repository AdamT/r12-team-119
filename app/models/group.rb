require 'securerandom'
class Group < ActiveRecord::Base
  attr_accessible :title, :user_id, :slot_size, :start_date, :days
  before_create :assign_stuff
  validates_uniqueness_of :slug
  validates :slot_size, :numericality => {only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 120}
  validates :days, :numericality => {only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 14}
  belongs_to :user
  has_many :group_participants
  has_many :users, through: :group_participants


  def assign_stuff
    self.start_date = Time.now.to_date if self.start_date.blank?
    self.slot_size = 15 if self.slot_size.blank?
    self.days = 7 if self.days.blank?
    self.slug = SecureRandom.urlsafe_base64(12)
  end

  def valid_group_participants
    self.group_participants.select{|u| u.user && u.user.ready? }
  end
  def to_param
    slug
  end
  def owned_by?(user)
    return false unless user
    return false unless user.id
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
    @timecard = Timecard.new(start: self.start_date, slot_size: self.slot_size, days: self.days)
    @timecard.deserialize(serialized_timecard) if self.serialized_timecard
    @timecard
  end

  def timecard=(card)
    self.serialized_timecard = card.serialize
    @timecard = card
  end
end
