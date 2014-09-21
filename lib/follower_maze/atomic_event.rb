module FollowerMaze
  class AtomicEvent
    attr_reader :to, :event

    def initialize(event, to)
      @event = event
      @to    = to

      @event.instance_eval %Q{
        def destination
          [Base.connected_users.find(#{@to})]
        end
      }

    end

    def <=>(event)
      self.event <=> event.event
    end

    def handle!
      @event.handle!
    end
  end
end