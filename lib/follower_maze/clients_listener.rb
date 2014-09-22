module FollowerMaze
  class ClientsListener < Util::Listener
    def listen
      loop do
        begin
          conn = socket.accept
          user_id = conn.readline.strip.encode("UTF-8").to_i
          Base.connections << ClientConnection.new(conn, user_id)
          Base.logger.debug "User #{user_id} connected!"
        rescue Errno::EBADF, IOError
          break
        end
      end
    end
  end
end