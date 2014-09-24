require 'spec_helper'

RSpec.describe FollowerMaze::Notification::Buffer do
  subject { described_class.new }

  let(:event1) { double("FollowerMaze::Event", id: 1) }
  let(:event2) { double("FollowerMaze::Event", id: 2) }
  let(:event3) { double("FollowerMaze::Event", id: 3) }

  let(:n_class) { FollowerMaze::Notification }

  let(:n1) { n_class.new event1, 1 }
  let(:n2) { n_class.new event2, 1 }
  let(:n3) { n_class.new event2, 2 }
  let(:n4) { n_class.new event3, 1 }

  before(:each) do
    FollowerMaze::User.stub(:find).and_return FollowerMaze::User.new 1
  end

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

  context 'polling queue' do
    before(:each) do
      subject.put n2
      subject.put n4
      subject.put n1
    end

    it 'gets notification in correct order' do
      expect(subject.buffer[1].poll).to eq n1
      expect(subject.buffer[1].poll).to eq n2
      expect(subject.buffer[1].poll).to eq n4
    end
  end
end