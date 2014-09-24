module FollowerMaze
  class Event
    module Types
      class Unfollow < Event
        notify false

        before_notification do |to_user, event|
          to_user.remove_follower event.from
        end
      end
    end
  end
end