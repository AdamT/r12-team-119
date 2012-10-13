class Slice
  attr_reader :slot_count, :start, :slots
  def initialize(options = {})
    # Slots for the slice
    @slots = options[:slots] || []
    @slot_size = options[:slot_size] || 15
    @slot_offset = options[:slot_offset] || 0
    @start = options[:start] || Time.now.to_date
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
