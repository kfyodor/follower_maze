module FollowerMaze
  class Event
    class Follow < Event
      def before_notify(user)
        user.add_follower(from)
      end
    end
  end
end