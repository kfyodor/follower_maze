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
        log_notification_sent
      end
    end

    private

    def log_notification_sent
      Base.logger.debug "Sent #{@event.class.name.split('::').last} to #{@to_user.id}"
    end
  end
end