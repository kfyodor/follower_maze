module FollowerMaze
  class Event
    module Types
      class Broadcast < Event
        deliver_notifications_to do |_|
          User.all
        end
      end
    end
  end
end