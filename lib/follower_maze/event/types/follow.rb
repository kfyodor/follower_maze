module FollowerMaze
  class Event
    module Types
      class Follow < Event
        before_notification do |to_user, event|
          to_user.add_follower(event.from)
        end
      end
    end
  end
end