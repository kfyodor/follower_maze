module FollowerMaze
  class Event
    class Dispatcher
      def initialize
        @storage  = Event::SequentialStorage.new
        @buffer   = Queue.new
        @consumer = nil
        @sender   = nil
        @mutex    = Mutex.new
        @users    = Base.users
      end

      def <<(event)
        @mutex.synchronize do
          @storage << event
        end
      end

      def start
        @sender = Thread.new do
          loop do 
            event = @buffer.pop
            Event::Handler.from_event(event).handle!
          end
        end

        @consumer = Thread.new do
          loop do
            @mutex.synchronize do
              if @storage.has_next?
                $events_received += 1
                @buffer << @storage.get_next!
              end
            end
          end
        end
      end

      def stop
        @consumer.kill
        @sender.kill
      end
    end
  end
end