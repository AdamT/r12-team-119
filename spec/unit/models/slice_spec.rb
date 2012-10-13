require 'spec_helper'

describe Slice do
  # TODO: implement these:
  #
  subject{
    Slice.new(days: [Day.new], slot_offset: 2)
  }
  its(:date){
    should == (Time.now + 60*2*15).to_datetime
  }

end
