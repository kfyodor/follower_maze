module FollowerMaze
  class Event
    module Types
      class Broadcast < Event
        def deliver_to
          User.all
        end
      end
    end
  end
end