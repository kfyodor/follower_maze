require 'spec_helper'

describe FollowerMaze::Util::SequenceChecker do
  subject { FollowerMaze::Util::SequenceChecker.new }

  let(:event) do
    Struct.new(:id, :to, :from, :type) do
      def <=>(event)
        self.id <=> event.id
      end
    end
  end

  it 'complete? works correctly' do
    subject << event.new(1)
    subject << event.new(3)

    expect(subject.instance_variable_get(:@sequence).values.to_a.map(&:id)).to eq [1,3]
    expect(subject.send(:complete?)).to eq false

    subject << event.new(4)
    subject << event.new(2)

    expect(subject.instance_variable_get(:@sequence).values.to_a.map(&:id)).to eq [1,2,3,4]
    expect(subject.send(:complete?)).to eq true
  end
end