module FollowerMaze
  class Event
    class StatusUpdate < Event
      def destination
        if from_user
          Base.connected_users.find_many(from_user.followers)
        else
          []
        end
      end

      def multiple?
        true
      end
    end
  end
end