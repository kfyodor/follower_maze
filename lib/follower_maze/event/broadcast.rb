module FollowerMaze
  class Event
    class Broadcast < Event
      def handle!
        Base.connected_users.each do |u|
          u.notify @payload
          puts "Sent broadcast to #{u.user_id}"
        end
      end
    end
  end
end