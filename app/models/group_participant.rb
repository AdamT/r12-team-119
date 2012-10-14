class GroupParticipant < ActiveRecord::Base
  attr_accessible :group_id, :user_id
  belongs_to :group
  belongs_to :user
  def mask_timecard_with(other)
    timecard.mask_with(other)
    self.serialized_timecard = timecard.serialize
  end
  def fill_timecard_with(params)
    timecard.fill_with(params)
    timecard.mask_with(group.timecard) if self.group
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
