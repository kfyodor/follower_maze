require 'spec_helper'

describe FollowerMaze::User do
  subject { described_class.new(1) }

  let(:user) { double("user") }

  class Conn; def write(data) end; end

  context 'Class methods' do
    subject { described_class }

    before(:each) do
      subject.class_variable_set :@@users, {1 => user, 2 => user, 3 => user}
    end

    it 'returns all' do
      expect(subject.all).to eq [user, user, user]
    end

    it 'finds user' do
      expect(subject.find(1)).to eq user
    end

    it 'finds_many users' do
      expect(subject.find_many([1,2])).to eq [user, user]
    end

    it 'creates user' do
      expect { subject.create(4) }.to change{ subject.all.count }.by 1
    end

    it 'finds or creates user' do
      expect(subject.find_or_create(2)).to eq user
      expect { subject.find_or_create(4) }.to change{ subject.all.count }.by 1
    end
  end

  context 'instance methods' do
    it 'adds follower' do
      subject.add_follower(5)
      expect(subject.followers).to eq [5]
    end

    it 'removes follower' do
      subject.add_follower(5)
      subject.remove_follower(5)
      expect(subject.followers).to eq []
    end
  end

  context 'notifying' do
    it 'notifies user' do
      conn = Conn.new
      user = described_class.new(1, connection: conn)
      data = "111"
      expect(conn).to receive(:write).with(data)
      user.notify data
    end
  end
end