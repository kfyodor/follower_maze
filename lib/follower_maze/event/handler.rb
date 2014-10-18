module FollowerMaze
  class Event
    class Handler
      def initialize(event)
        @event, @users = event, Base.users
      end

      def self.from_event(event)
        case event.type
        when "P"
          PrivateMessage
        when "F"
          Follow
        when "U"
          Unfollow
        when "S"
          StatusUpdate
        when "B"
          Broadcast
        else
        end.new(event)
      end

      private

      %w(from to).each do |m|
        define_method "#{m}_user" do
          @users.find(@event.send m)
        end
      end
    end

    class Handler::PrivateMessage < Handler
      def handle!
        to_user.notify(@event.payload)
      end
    end

    class Handler::Follow < Handler
      def handle!
        to_user.add_follower @event.from
        to_user.notify(@event.payload)
      end
    end

    class Handler::Unfollow < Handler
      def handle!
        to_user.remove_follower @event.from
      end
    end

    class Handler::StatusUpdate < Handler
      def handle!
        from_user.followers.each do |user_id|
          @users.find(user_id).notify @event.payload
        end
      end
    end

    class Handler::Broadcast < Handler
      def handle!
        @users.all.each do |user|
          user.notify @event.payload
        end
      end
    end
  end
end