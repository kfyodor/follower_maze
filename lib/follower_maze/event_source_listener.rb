# load "./lib/follower_maze.rb"; FollowerMaze::Base.new.run

module FollowerMaze
  class EventSourceListener
    def initialize
      @socket = TCPServer.new(EVENT_SOURCE_PORT).tap do |s|
        s.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
      end
    end

    def listen
      counter = 0
      Thread.new(@socket.accept) do |conn|
        # sleep 0.1
        begin 
          loop do
            raise "EOF" if conn.eof?
            data    = conn.gets(DELIMITER).strip
            message = Event.from_payload(data)
            message.handle!
          end
        rescue => e
          puts e.message
          puts e.backtrace
          conn.close
        end
      end
    end
  end
end