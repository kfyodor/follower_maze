module FollowerMaze
  class Dispatcher
    def initialize
      @sequence_checker     = Util::SequenceChecker.new
      @notifications_buffer = {}
      @thread_pool          = ThreadPool.new
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
      @notifications_buffer.clear
    end

    def build_notifications
      events.map(&:build_notifications).flatten.each do |n|
        @notifications_buffer[n.to] = (@notifications_buffer[n.to] || SortedSet.new) << n
      end
    end

    def flush!
      build_notifications

      @notifications_buffer.each do |_, notifications|
        @thread_pool.add_work(notifications) do |n|
          notifications.each &:handle!
        end
      end
      @thread_pool.work

      reset!
    end
  end
end