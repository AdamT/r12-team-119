require 'spec_helper'

describe Timeslots do
  its(:day_size){ should == 96 }

  context '5 minute intervals' do
    subject{ Timeslots.new({}, 5) }
    its(:day_size){ should == 288 }
  end

end
