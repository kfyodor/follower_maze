# require 'spec_helper'

# describe FollowerMaze::Util::SequenceChecker do
#   EventStub = Struct.new(:id, :to, :from, :type) do
#     def <=>(event)
#       self.id <=> event.id
#     end
#   end

#   before do
#     @sequence_checker = FollowerMaze::Util::SequenceChecker.new

#     [:flush, :expand_and_cache_event].each do |method|
#       expect(@sequence_checker).to receive(method) { nil }
#     end
#   end



#   it 'complete? works correctly' do
#     @sequence_checker << EventStub.new(1)
#     @sequence_checker << EventStub.new(3)

#     expect(@sequence_checker.instance_variable_get(:@sequence).values.to_a.map(&:id)).to eq [1,3]
#     expect(@sequence_checker.send(:complete?)).to be_false

#     @sequence_checker << EventStub.new(4)
#     @sequence_checker << EventStub.new(2)

#     expect(@sequence_checker.instance_variable_get(:@sequence).values.to_a).to eq [1,2,3,4]
#     expect(@sequence_checker.send(:complete?)).to be_true
#   end
# end