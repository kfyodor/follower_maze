module FollowerMaze
  class Event
    class Unfollow < Event
      def before_notify(user)
        if from_user
          user.remove_follower from
        end
      end

      def notify?
        false
      end
    end
  end
end