class Timeslots
  def initialize(days = {}, size_in_minutes = 15 )
    @size = size_in_minutes
    @days = days
    setup_days
  end

  def each_slot
  end

  def setup_days
    @days.default = Hash.new(false)
    @days.each do |k, hash|
      hash.default = false
    end
  end

  def day_size
    (60*24)/@size
  end
end
