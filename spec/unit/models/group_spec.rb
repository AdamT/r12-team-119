require 'spec_helper'

describe Group do
  its(:slot_size){ should == 15 }
  its(:days){ should == 7 }

  let(:group_params) {
    # first hours of monday or tuesday
    {
      "0" => { "0" => true, "1" => true, "2" => true, "3" => true},
      "1" => { "0" => true, "1" => true, "2" => true, "3" => true}
    }
  }
  let(:p1_params){
    # first participant free any time
    {
      "0" => { "0" => true, "1" => true, "2" => true, "3" => true},
      "1" => { "0" => true, "1" => true, "2" => true, "3" => true}
    }
  }
  let(:p2_params){
    # second participant only available tuesday
    {
      "1" => { "0" => true, "1" => true, "2" => true, "3" => true}
    }
  }
  it 'should have tuesday as the best timeslot' do
    subject.timecard.fill_with(group_params)
    subject.save!

    p1 = subject.group_participants.create!
    p2 = subject.group_participants.create!

    p1.fill_timecard_with(p1_params)
    p2.fill_timecard_with(p2_params)

    # FIXME p1 and p2 serialized_timecard don't have expected values

    p1.save!
    p2.save!

    best = subject.reload.best_timeslots
  end
end
