module FollowerMaze
  class Event
    class SequentialStorage
      def initialize
        @events  = {}
        @next_id = 1
        @mutex   = Mutex.new
      end

      def <<(event)
        @events[event.id.to_i] = event
      end

      def has_next?
        @events.has_key? @next_id
      end

      def get_next!
        @events.delete(@next_id).tap do
          @next_id += 1
        end
      end
    end
  end
end