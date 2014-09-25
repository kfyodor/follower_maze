module FollowerMaze
  class ClientsListener < Util::Server
    def listen
      loop do
        begin
          conn    = socket.accept
          user_id = conn.readline.strip.encode("UTF-8").to_i

          Base.connections << User::Connection.new(conn, user_id)

          Base.logger.debug "User #{user_id} connected!"
        rescue Errno::EBADF, IOError
          Base.logger.error "Event listener connection error."
          next
        end
      end
    end
  end
end