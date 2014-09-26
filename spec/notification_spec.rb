require 'spec_helper'

describe FollowerMaze::Notification do
  let(:event) { instance_double "FollowerMaze::Event", id: 1, payload: "111", notify?: true }
  let(:event_without_notify) { 
    instance_double "FollowerMaze::Event", id: 1, payload: "111", notify?: false
  }

  let(:user) { FollowerMaze::User.new 1 }

  let(:notification) { described_class.new event, user }
  let(:notification2) { described_class.new event_without_notify, user }

  it 'is being handled' do
    expect(user).to receive(:notify).with("111")
    notification.handle!
  end

  it 'is not sent if notify false' do
    expect(user).not_to receive(:notify)
    notification2.handle!
  end
end