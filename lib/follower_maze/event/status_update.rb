module FollowerMaze
  class Event
    class StatusUpdate < Event

      def handle!
        return unless from_user

        Base.connected_users.find_many(from_user.followers).each do |u|
          u.notify @payload
          puts "Sent status update to #{u.user_id}"
        end
      end

    end
  end
end