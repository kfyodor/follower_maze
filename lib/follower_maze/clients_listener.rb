module FollowerMaze
  class ClientsListener
    attr_reader :connections

    def initialize
      @socket = TCPServer.new(CLIENTS_PORT).tap do |s|
        s.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
      end
    end

    def listen
      loop do
        Thread.new(@socket.accept) do |conn|
          user_id = conn.gets(DELIMITER).strip.to_i
          Base.connections << UserConnection.new(conn, user_id)
        end
      end
    end
  end
end