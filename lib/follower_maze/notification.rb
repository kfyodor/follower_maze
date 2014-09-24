module FollowerMaze
  class Notification
    include java.lang.Comparable

    attr_reader :to, :event
    
    def initialize(event, to)
      @event   = event
      @to      = to
      @to_user = User.find(to)
    end

    def compareTo(notification)
      self.event.id <=> notification.event.id
    end

    def handle!
      if @to_user
        @to_user.notify(@event.payload) if @event.notify?
        @event.after_notify @to_user
      end
    end
  end
end