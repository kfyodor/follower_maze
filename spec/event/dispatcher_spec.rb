require 'spec_helper'

describe FollowerMaze::Event::Dispatcher do
  subject { described_class.new }

  let(:event1) { instance_double("FollowerMaze::Event", id: 1) }
  let(:event2) { instance_double("FollowerMaze::Event::Types::Follow", id: 2) }
  let(:sc) { subject.instance_variable_get(:@sequence_checker) }
  
  it 'adds event' do
    sc.should_receive(:<<).with(event2)
    sc.should_receive(:complete?).and_return false

    subject << event2
  end

  it 'calls flush if sequence is complete' do
    sc.should_receive(:complete?).and_return true
    subject.stub(:flush!).and_return nil
    subject.should_receive(:flush!)
    

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
      sc.stub(:complete?).and_return true
      subject.stub(:events).and_return [event2]

      event2.should_receive(:has_side_effects?).and_return true
      event2.should_receive(:before_callback)
      event2.should_receive(:build_notifications)
      sc.should_receive(:next)

      subject << event2
    end
  end
end