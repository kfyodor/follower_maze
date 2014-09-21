# load "./lib/follower_maze.rb"; FollowerMaze::Base.new.run!

module FollowerMaze
  class EventSourceListener < Util::Listener
    def listen
      loop do
        puts "====> Event source listener is ready to acceptt new connections."
        Thread.new(socket.accept) do |conn|
          sleep 0.2 # Don't like sleep. Conditional variable? Fiber? :)
          until conn.eof?
            data = conn.gets(DELIMITER).strip
            Base.events_buffer << Event.from_payload(data)
          end
          puts "====> Event source disconected."
        end.join
      end
    end
  end
end