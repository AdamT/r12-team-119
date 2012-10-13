class Timecard
  attr_reader :days, :slot_size, :start
  def initialize(options = {})
    # Slot size is defined in minute lengths
    @slot_size = options[:slot_size] || 15
    # Time slot length is number of days
    @days = options[:days] || 7
    @start = options[:start] || Time.now.to_date.to_datetime
    setup_days
  end

  def each_slot(&block)
    each_day.flat_map do |day|
      day.slots
    end.each(&block)
  end
  def each_day(&block)
    @day_list.each(&block)
  end

  def each_slice(&block)
    slots = slots_per_day.times.map do |i|
      Slice.new(slot_offset: i, days: days, start: start, slot_size: slot_size)
    end.each(&block)
  end

  def setup_days
    @day_list =
      days.times.map do |d|
        Day.new(start: start, offset: d, slots: slots_per_day)
      end
  end

  def slots_per_day
    (60*24)/@slot_size
  end

  def serialize
    each_day.map{|s| s.serialize }.join
  end
end
