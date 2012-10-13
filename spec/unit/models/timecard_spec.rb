require 'spec_helper'

describe Timecard do
  its(:slots_per_day){ should == 96 }
  its(:days){ should == 7 }

  context '5 minute intervals' do
    subject{ described_class.new(slot_size: 5) }
    its(:slots_per_day){ should == 288 }
  end
  context '1 day long' do
    subject{ described_class.new(days: 1) }
    its(:slots_per_day){ should == 96 }
    its(:days){ should == 1 }
  end
  context '1 day, 60 minute slots' do
    subject{ described_class.new(days: 1, slot_size: 60) }
    let(:expected_serialization){
      "0"*24
    }
    its(:slots_per_day){ should == 24 }
    its(:days){ should == 1 }
    it 'serializes' do
      subject.serialize.should == expected_serialization
    end
  end

end
