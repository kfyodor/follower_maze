module FollowerMaze
  class EventSourceListener
    include Util::Server

    attr_reader :dispatcher

    def initialize
      @dispatcher = Event::Dispatcher.new
      @port       = FollowerMaze.config.event_source_port
      @host       = FollowerMaze.config.event_source_host
    end

    def stop
      @dispatcher.stop
      super
    end

    def listen
      @dispatcher.start

      loop do
        $logger.info "====> Event source listener is ready to accept new connections on port #{port}."

        begin
          conn = socket.accept

          until conn.eof?
            @dispatcher << Event.new(conn.readline.strip)
          end

        rescue Errno::EBADF, IOError
          $logger.error "Event listener connection error."
          next # won't work if you repeat the provided test
               # without restarting the server
               # because in real life we can't go back in time,
               # delete all followers from the database
               # and regenerate events
        end
        $logger.info "====> Event source disconnected."
      end
    end
  end
end