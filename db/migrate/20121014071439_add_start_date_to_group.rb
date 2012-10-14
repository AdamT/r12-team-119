class AddStartDateToGroup < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.date :start_date
      t.integer :slot_size, :default => 15
      t.integer :days, :default => 7
    end

    Group.all.each do |u|
      u.start_date = Timecard.new.date.to_date + 2
      u.save
    end


  end
end
