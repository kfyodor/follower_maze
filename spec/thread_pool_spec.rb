require 'spec_helper'

describe FollowerMaze::ThreadPool do
  subject { described_class.new }
  let(:notification) { double "notification" }
  let(:block) { ->(_){} }


  it 'adds work' do
    expect do
      subject.add_work notification, 1, &block
    end.to change { subject.waiting.size }.by 1
  end

  context 'getting work' do
    it 'gets work'
    it 'gets another work if id is in working'
  end

  it 'keeps limited amount of threads'

end