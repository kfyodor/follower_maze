module FollowerMaze
  class Event
    class StatusUpdate < Event
      def destination
        User.find_many(from_user.followers)
      end
    end
  end
end