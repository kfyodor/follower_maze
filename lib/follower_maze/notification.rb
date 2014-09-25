module FollowerMaze
  class Notification
    attr_reader :to_user, :event
    
    def initialize(event, to_user)
      @event   = event
      @to_user = to_user
    end

    def handle!
      @to_user.notify(@event.payload) if @event.notify?
      log_notification_sent
    end

    private

    def log_notification_sent
      Base.logger.debug "Sent #{@event.class.name.split('::').last} to #{@to_user.id}"
    end
  end
end