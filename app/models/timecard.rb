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

  def fetch(day, slot)
    @day_list[day][slot]
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
      Slice.new(slot_offset: i, days: @day_list, start: start, slot_size: slot_size)
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

  def deserialize(serialized)
    raise "Can't deserialize!" unless serialized.length == @days * slots_per_day
    each_day {|d| d.deserialize(serialized.slice(d.offset * slots_per_day, slots_per_day))}
  end

  def fill_with(params)
    params.each do |day, slots|
      slots.each do |slot_num, bool|
        @day_list[day.to_i].slots[slot_num.to_i] = bool
      end
    end

    self
  end

  def maskable?(other_timecard)
    @start == other_timecard.start && @days == other_timecard.days && other_timecard.slot_size % @slot_size == 0
  end

  def mask_with(other_timecard)
    raise "Timecard mismatch!" unless maskable?(other_timecard)
    # assuming slot_sizes are equal for now
    deserialize((self.serialize.to_i(2) & other_timecard.serialize.to_i(2)).to_s(2).rjust(@days * slots_per_day, "0"))
  end
end
