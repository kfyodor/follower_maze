module FollowerMaze
  class Notification
    class Buffer
      attr_reader :buffer

      def initialize
        @buffer = {}
      end

      def << (notification)
        user_id = notification.to

        value = if @buffer.has_key?(user_id)
          @buffer[user_id]
        else
          java.util.PriorityQueue.new
        end << notification

        @buffer[user_id] = value
      end
      alias_method :put, :<<

      def each(&block)
        @buffer.each &block
      end

      def size
        @buffer.size
      end
    end
  end
end