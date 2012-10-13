class Slice
  attr_reader :slot_count, :start, :days, :slot_offset
  def initialize(options = {})
    # Slots for the slice
    @days = options[:days] || []
    @slot_size = options[:slot_size] || 15
    @slot_offset = options[:slot_offset] || 0
    @start = options[:start] || Time.now.to_datetime
  end

  # TODO: Implement so we can convert time represented by slice
  # to a string
  def date
    start
  end

  def minutes
    date.min
  end

  def hours
    date.hour
  end

  def each_slot
    days.map{|day| day[slot_offset] }
  end

end
