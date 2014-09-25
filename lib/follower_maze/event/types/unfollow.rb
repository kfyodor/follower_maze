module FollowerMaze
  class Event
    module Types
      class Unfollow < Event
        def notify?
          false
        end

        def before_callback
          to_user.remove_follower from
        end
      end
    end
  end
end