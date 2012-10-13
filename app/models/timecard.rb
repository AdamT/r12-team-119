class Timecard
  attr_reader :days, :slot_size, :start
  def initialize(options = {})
    # Slot size is defined in minute lengths
    @slot_size = options[:slot_size] || 15
    # Time slot length is number of days
    @days = options[:days] || 7
    @start = options[:start] || Time.now.to_date
    setup_days
  end

  def each_slot
    each_day.flat_map do |day|
      day.slots
    end
  end
  def each_day
    @day_list.each
  end

  def each_slice
    slots_per_day.times.map do |i|
      days.map{|d| d[i] }
    end
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
