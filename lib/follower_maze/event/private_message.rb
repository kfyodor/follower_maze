module FollowerMaze
  class Event
    class PrivateMessage < Event

      def handle!
        if to_user
          to_user.notify(@payload)
          puts "Sent private message to #{to}"
        end
      end

    end
  end
end