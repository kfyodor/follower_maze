module FollowerMaze
  class Dispatcher
    attr_reader :notifications_built, :notifications_sent
    def initialize
      @sequence_checker = Util::SequenceChecker.new
      @thread_pool      = ThreadPool.new

      @thread_pool.run
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

    def build_notifications
      events.reduce(NotificationsBuffer.new) do |buffer, event|
        buffer.tap do |b|
          event.build_notifications.each { |n| b << n }
        end
      end
    end

    def flush!
      build_notifications.each do |k, notifications|
        @thread_pool.add_work(notifications, k) do |queue|
          until queue.empty?
            queue.poll.handle!
          end
        end
      end

      reset!
    end
  end
end