module FollowerMaze
  class Event
    class Broadcast < Event
      def destination
        User.all
      end
    end
  end
end