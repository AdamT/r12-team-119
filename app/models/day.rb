class Day
  attr_reader :slot_count, :offset, :start, :slots
  def initialize(options = {})
    # Slot count for the day (default of 15-minute slots for 24 hours)
    @slot_count = options[:slots] || 96
    # The day offset
    @offset = options[:offset] || 0
    @start = options[:start] || Time.now.to_datetime
    setup_slots
  end

  def [](index)
    @slots[index]
  end

  def setup_slots
    @slots = Array.new(@slot_count, false)
  end

  def each_slot
    slots.each
  end

  def serialize
    each_slot.map{|s| s ? "1":"0" }.join
  end

end
