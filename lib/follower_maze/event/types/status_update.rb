module FollowerMaze
  class Event
    module Types
      class StatusUpdate < Event
        def deliver_to
          User.find_many(from_user.followers)
        end
      end
    end
  end
end