module FollowerMaze
  class Event
    class Dispatcher
      def initialize
        @sequence_checker = Util::SequenceChecker.new
        @buffer           = Queue.new
        @consumer         = nil
      end

      def <<(event)
        @sequence_checker << event
        flush! if @sequence_checker.complete?
      end

      def start
        @consumer = Thread.new do
          loop { @buffer.pop.handle! }
        end
      end

      def stop
        @consumer.kill
      end

      private

      def events
        @sequence_checker.data
      end

      def flush!
        build_notifications_from_events
        @sequence_checker = @sequence_checker.next
      end

      def build_notifications_from_events
        events.each do |event|
          event.build_notifications do |n|
            @buffer << n
          end
        end
      end
    end
  end
end