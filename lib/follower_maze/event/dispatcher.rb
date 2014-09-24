module FollowerMaze
  class Event
    class Dispatcher
      def initialize
        @sequence_checker = Util::SequenceChecker.new
        @notifications    = Queue.new

        start
      end

      def <<(event)
        @sequence_checker << event
        flush! if @sequence_checker.complete?
      end

      private

      def events
        @sequence_checker.data
      end

      def reset!
        @sequence_checker = @sequence_checker.next
      end

      def add(notification)
        @notifications << notification
      end

      def start
        Thread.new do
          loop do
            @notifications.deq.handle!
          end
        end
      end

      def flush!
        events.map do |event|
          event.build_notifications.each { |n| add n }
          # buffer.tap do |b|
          #   event.build_notifications.each { |n| b << n }
          # end
        end

        reset!
      end
    end
  end
end