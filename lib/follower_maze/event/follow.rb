module FollowerMaze
  class Event
    class Follow < Event

      def handle!
       if to_user
          to_user.add_follower(from)
          to_user.notify(@payload)
          puts "Sent Follow to #{to}"
        end
      end

    end
  end
end