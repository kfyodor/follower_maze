# load "./lib/follower_maze.rb"; FollowerMaze::Base.new.run!

module FollowerMaze
  class EventSourceListener < Util::Listener
    def listen
      loop do
        begin
          puts "====> Event source listener is ready to acceptt new connections."
          conn = socket.accept

          sleep 0.2
          until conn.eof?
            data = conn.gets(DELIMITER).strip
            Base.events_buffer << Event.from_payload(data)
          end
          puts "====> Event source disconected."
        rescue Errno::EBADF, IOError
          break
        end
      end
    end
  end
end