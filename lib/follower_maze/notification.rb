module FollowerMaze
  class Notification
    attr_reader :to, :event
    
    def initialize(event, to)
      @event   = event
      @to      = to
      @to_user = User.find(to)
    end

    def <=>(event)
      self.event.id <=> event.event.id
    end

    def handle!
      if @to_user
        @to_user.notify(@event.payload) if @event.notify?
        @event.after_notify @to_user
      end
    end
  end
end