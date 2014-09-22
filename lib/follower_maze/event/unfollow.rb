module FollowerMaze
  class Event
    class Unfollow < Event
      def before_notify(user)
        user.remove_follower from
      end

      def notify?
        false
      end
    end
  end
end