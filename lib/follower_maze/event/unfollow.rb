module FollowerMaze
  class Event
    class Unfollow < Event

      def handle!
        if to_user
          to_user.remove_follower(from)
        end
      end

    end
  end
end