module FollowerMaze
  class ClientsListener
    include Util::Server

    def initialize
      @port = FollowerMaze.config.clients_port
      @host = FollowerMaze.config.clients_host
    end

    def listen
      loop do
        begin
          conn    = socket.accept
          user_id = conn.readline.strip

          Base.users << User.new(user_id, conn)

          $logger.debug "User #{user_id} connected!"
        rescue Errno::EBADF, IOError
          Base.connections.disconnect!
          $logger.error "Event listener connection error."
          next
        end
      end
    end
  end
end