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

  # TODO: implement these:
  #
  let(:params){
    # Free the first hour of monday.
    { "0" => { "0" => true, "1" => true, "2" => true, "3" => true} }
  }
  let(:other_params){
    # Free the first hour of tuesday.
    { "1" => { "0" => true, "1" => true, "2" => true, "3" => true} }
  }
  it 'should allow filling with matrix' do
    pending
    subject.fill_with(params)
  end

  # Other timecard that only has the first hour of the day
  let(:other_timecard){
    t = described_class.new
    t.fill_with(other_params)
  }
  it 'should allow masking with other timecard (group settings)' do
    pending
    subject.fill_with(params)
    subject.mask_with(other_timecard)
    # should serialize to all 0s.
  end

end
