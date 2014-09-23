module FollowerMaze
  class EventSourceListener < Util::Listener
    def initialize(*args)
      @dispatcher = FollowerMaze::Dispatcher.new
      super(*args)
    end

    def listen
      loop do
        begin
          Base.logger.info "====> Event source listener is ready to accept new connections."
          conn = socket.accept

          until conn.eof? do
            data = conn.readline.strip.encode("UTF-8")
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