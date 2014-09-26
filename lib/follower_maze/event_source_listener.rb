module FollowerMaze
  class EventSourceListener < Util::Server
    attr_reader :dispatcher

    def initialize(*args)
      @dispatcher = Event::Dispatcher.new
      super(*args)
    end

    def stop
      @dispatcher.stop
      super
    end

    def listen
      @dispatcher.start

      loop do
        Base.logger.info "====> Event source listener is ready to accept new connections."

        begin
          conn = socket.accept

          until conn.eof?
            data = conn.readline.strip
            @dispatcher << Event.from_payload(data)
          end

        rescue Errno::EBADF, IOError
          Base.logger.error "Event listener connection error."
          next
        ensure
          ### this is only for test purposes
          # @dispatcher.stop
          # @dispatcher = Event::Dispatcher.new
          # User.class_variable_set :@@users, {}
          # Base.connections.disconnect_all!
          # @dispatcher.start
        end
        Base.logger.info "====> Event source disconnected."
      end
    end
  end
end