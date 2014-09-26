require 'spec_helper'

describe FollowerMaze::Event::Dispatcher do
  subject { described_class.new }

  let(:event1) { instance_double("FollowerMaze::Event", id: 1) }
  let(:event2) { instance_double("FollowerMaze::Event::Types::Follow", id: 2) }
  let(:sc) { subject.instance_variable_get(:@sequence_checker) }
  
  it 'adds event' do
    expect(sc).to receive(:<<).with(event2)
    expect(sc).to receive(:complete?) { false }

    subject << event2
  end

  it 'calls flush if sequence is complete' do
    allow(sc).to receive(:complete?) { true }
    allow(subject).to receive(:flush!) { nil }
    expect(subject).to receive(:flush!)
    

    subject << event1
  end

  it 'starts consumer thread' do
    subject.start
    sleep(0.1)
    expect(subject.instance_variable_get :@consumer).to be_instance_of(Thread)
    expect(subject.instance_variable_get(:@consumer).status)
      .to match /sleep|run/
  end

  it 'stops consumer thread' do
    subject.start
    subject.stop
    sleep(0.1)
    expect(subject.instance_variable_get(:@consumer).status)
      .to eq false
  end

  it 'has events' do
    subject << event2
    expect(subject.send(:events).to_a).to eq [event2]
  end

  context 'flush' do
    it 'flushes' do
      allow(sc).to receive(:complete?) { true }
      allow(subject).to receive(:events) { [event2] }

      expect(event2).to receive(:has_side_effects?) { true }
      expect(event2).to receive(:before_callback)
      expect(event2).to receive(:build_notifications)
      expect(sc).to receive(:next)

      subject << event2
    end
  end
end