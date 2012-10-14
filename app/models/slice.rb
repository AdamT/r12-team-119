class Slice
  attr_reader :slot_count, :start, :days, :slot_offset, :slot_size
  def initialize(options = {})
    # Slots for the slice
    @days = options[:days] || []
    @slot_size = options[:slot_size] || 15
    @slot_offset = options[:slot_offset] || 0
    @start = options[:start] || Time.now.to_datetime
  end

  def date
    (@start.to_date.to_time + (60 * slot_size * slot_offset)).to_datetime
  end

  def minutes
    date.min
  end

  def hours
    date.hour
  end

  def each_slot(&block)
    slots = days.map{|day| day[slot_offset] }
    slots.each(&block)
  end

end
