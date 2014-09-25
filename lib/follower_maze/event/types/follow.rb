module FollowerMaze
  class Event
    module Types
      class Follow < Event
        def before_callback
          to_user.add_follower(self.from)
        end
      end
    end
  end
end