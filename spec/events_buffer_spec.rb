require 'spec_helper'

describe FollowerMaze::EventsBuffer do
  EventStub = Struct.new(:id, :to, :from, :type) do
    def <=>(event)
      self.id <=> event.id
    end
  end

  before do
    @events_buffer = FollowerMaze::EventsBuffer.new

    [:flush, :expand_and_cache_event].each do |method|
      expect(@events_buffer).to receive(method) { nil }
    end
  end



  it 'complete shoud work correctly' do
    @events_buffer << EventStub.new(1)
    @events_buffer << EventStub.new(3)

    expect(@events_buffer.instance_variable_get(:@events_buffer).to_a.map(&:id)).to eq [1,3]
    expect(@events_buffer.send(:complete_set?)).to be_false

    @events_buffer << EventStub.new(4)
    @events_buffer << EventStub.new(2)

    expect(@events_buffer.instance_variable_get(:@events_buffer).to_a).to eq [1,2,3,4]
    expect(@events_buffer.send(:complete_set?)).to be_true
  end
end