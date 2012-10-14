class AddSerializedTimecardToGroup < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.text :serialized_timecard
    end
    change_table :group_participants do |t|
      t.text :serialized_timecard
    end
    Group.all.each do |u|
      u.timecard = Timecard.new
      u.save
    end
  end
end
