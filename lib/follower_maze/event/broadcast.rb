module FollowerMaze
  class Event
    class Broadcast < Event
      def destination
        Base.connected_users
      end

      def multiple?
        true
      end
    end
  end
end