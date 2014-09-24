module FollowerMaze
  class Event
    module Types
      class StatusUpdate < Event
        deliver_notifications_to do |event|
          User.find_many(event.from_user.followers)
        end
      end
    end
  end
end