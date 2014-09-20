# load "./lib/follower_maze.rb"; FollowerMaze::Base.new.run!

module FollowerMaze
  class EventSourceListener < Util::Listener
    def listen
      counter = 0
      Thread.new(socket.accept) do |conn|
        sleep 0.2 # Don't like sleep. Conditional variable? Fiber? :)
        begin 
          loop do
            raise "EOF" if conn.eof?
            data    = conn.gets(DELIMITER).strip
            Base.events_buffer << Event.from_payload(data)
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