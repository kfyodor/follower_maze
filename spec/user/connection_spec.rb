require 'spec_helper'

describe FollowerMaze::User::Connection do

  class NullSocket
    def write(data)
    end

    def close
    end
  end

  subject { described_class.new(NullSocket.new, 1) }

  let(:socket) { subject.instance_variable_get(:@socket) }
  let(:data)   { "111" }

  it 'has user id' do
    expect(subject.user_id).to eq 1
  end

  it 'has user' do
    expect(subject.user.id).to eq 1
  end

  it 'writes data' do
    expect(socket).to receive(:write).with("#{data}\r\n")
    subject.write(data)
  end

  it 'disconnects' do
    expect(socket).to receive(:close)
    subject.disconnect
  end
end