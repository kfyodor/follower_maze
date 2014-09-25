require 'spec_helper'

describe FollowerMaze::Notification do
  let(:event1) { instance_double "FollowerMaze::Event", id: 1 }
  let(:event2) { instance_double "FollowerMaze::Event", id: 2 }

  before do
    FollowerMaze::User.stub(:find).and_return(FollowerMaze::User.new 1)
  end

  let(:notification1) { described_class.new event1, 2 }
  let(:notification2) { described_class.new event2, 1 }

  # it 'compares notifications' do
  #   expect(notification1 < notification2).to  eq true
  #   expect(notification1 <= notification2).to eq true
  #   expect(notification1 > notification2).to  eq false
  #   expect(notification1 >= notification2).to eq false
  #   expect(notification1 == notification2).to eq false
  #   expect(notification1 <=> notification2).to eq -1
  # end
end