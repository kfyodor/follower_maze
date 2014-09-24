module FollowerMaze
  class EventSourceListener < Util::Server
    def initialize(*args)
      @dispatcher = Event::Dispatcher.new
      super(*args)
    end

    def listen
      loop do
        begin
          Base.logger.info "====> Event source listener is ready to accept new connections."
          conn = socket.accept

          until conn.eof?
            data = conn.readline.strip
            @dispatcher << Event.from_payload(data)
          end

          Base.logger.info "====> Event source disconnected."
        rescue Errno::EBADF, IOError
          Base.logger.error "Connection error."
          break
        end
      end
    end
  end
end