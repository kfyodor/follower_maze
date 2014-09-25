require 'spec_helper'

describe FollowerMaze::Event do
  context 'class methods' do
    subject { described_class }

    class TestEvent < described_class
      attr_accessor :before_called

      def initialize(*args)
        @before_called = 0
        super *args
      end

      def before_notification
        @before_called += 1
      end

      def deliver_to
        FollowerMaze::User.all
      end
    end

    it 'gets new type when inherited' do
      expect(subject.types["T"]).to eq TestEvent
    end

    context 'event from payload' do
      subject { described_class.from_payload("111|T|2|3") }

      it { is_expected.to be_instance_of TestEvent }
      it { is_expected.to have_attributes({ id: 111, type: "T", payload: "111|T|2|3", to: 3, from: 2 }) }
    end
  end

  context 'instance methods' do
    context 'abstract class' do
      it 'raises an error' do
        expect {
          described_class.new(1,2,3,4,5)
        }.to raise_error(FollowerMaze::Event::AbstractClassError)
      end
    end

    context 'inherited class' do
      subject { TestEvent.new "111|T|2|3", "111", "T", "2", "3" }

      let(:user_class) { FollowerMaze::User }
      let(:users) { [user_class.new(1), user_class.new(2), user_class.new(3)] }

      context 'attrs' do
        it 'has correct recipients' do
          user_class.should_receive(:all).and_return(users)
          expect(subject.deliver_to).to eq users
        end

        it 'has correct notify?' do
          expect(subject.notify?).to eq true
        end
      end

      context 'building notifications' do
        it 'calls before hook destination.size times' do
          expect do
            subject.before_notification
          end.to change(subject, :before_called).by 1
        end

        it 'builds notifications' do
          buffer = []
          subject.build_notifications do |n|
            buffer << n
          end
          expect(
            buffer.map {|n| n.to_user.id }
          ).to eq [1, 2, 3]
        end
      end
    end
  end
end