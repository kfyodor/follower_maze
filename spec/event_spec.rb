require 'spec_helper'

describe FollowerMaze::Event do
  context 'class methods' do
    subject { described_class }

    class TestEvent < described_class
      attr_reader :before_called

      def initialize(*args)
        @before_called = 0
        super *args
      end

      def before_notify(_)
        @before_called += 1
      end

      def destination
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

      context 'destination' do
        before(:each) do
          user_class.should_receive(:all).and_return(users)
        end

        it { is_expected.to have_attributes({ destination: users }) }
      end

      context 'users' do
        before(:each) do
          user_class.should_receive(:find_or_create).and_return(users.first)
        end

        it { is_expected.to have_attributes({ to_user: users.first })}
        it { is_expected.to have_attributes({ from_user: users.first })}
      end

      context 'building notifications' do
        it 'calls before hook destination.size times' do
          expect do
            subject.build_notifications
          end.to change(subject, :before_called).by 3
        end

        it 'builds notifications' do
          expect(
            subject.build_notifications.map do |n|
              [n.to, n.event]
            end
          ).to eq [[1, subject], [2, subject], [3, subject]]
        end
      end
    end
  end
end