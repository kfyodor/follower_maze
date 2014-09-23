require 'spec_helper'

RSpec.describe FollowerMaze::NotificationsBuffer do
  subject { described_class.new }

  let(:event1) { double("FollowerMaze::Event", id: 2) }
  let(:event2) { double("FollowerMaze::Event", id: 2) }
  let(:n_class) { "FollowerMaze::Notification" }
  let(:n1) { instance_double n_class, to: 1, event: event1 }
  let(:n2) { instance_double n_class, to: 1, event: event2 }
  let(:n3) { instance_double n_class, to: 2, event: event1 }

  it 'puts key to buffer' do
    expect { subject.put n1 }.to change(subject, :size).by 1
  end

  context "put with same user ids" do
    before(:each) do 
      subject.put n1
      subject.put n2
    end

    it { is_expected.to satisfy { |s| s.buffer.keys == [1] } }
    it { is_expected.to satisfy { |s| s.buffer[1].size == 2 } }
    it { is_expected.to satisfy { |s| s.buffer[1].to_a == [n1, n2] }}
  end

  context "put with different user ids" do
    before(:each) do 
      subject.put n1
      subject.put n3
    end

    it { is_expected.to satisfy { |s| s.buffer.keys == [1, 2] } }
    it { is_expected.to satisfy { |s| s.buffer[1].size == 1 } }
    it { is_expected.to satisfy { |s| s.buffer[2].size == 1 } }
  end
end