module FollowerMaze
  class ClientsListener < Util::Listener
    def listen
      loop do
        Thread.new(socket.accept) do |conn|
          user_id = conn.gets(DELIMITER).strip.to_i
          Base.connected_users << UserConnection.new(conn, user_id)
          puts "User #{user_id} connected!"
        end
      end
    end
  end
end