module FollowerMaze
  class Event
    attr_reader :id, :type, :to, :from, :payload

    @@types        = {}
    @@before_hooks = []
    @@after_hooks  = []

    class << self
      def inherited(klass)
        klass_name = klass.name
        type_id    = klass_name.split('::').last[0].upcase

        @@types[type_id] = klass_name
      end

      def from_payload(payload)
        id, type, from, to = payload.split('|')
        klass = Object.const_get(@@types[type])

        klass.new(payload, id, type, from, to)
      end
    end

    def initialize(payload, id, type, from, to)
      @payload = payload
      @id      = id.to_i
      @type    = type
      @from    = from.to_i
      @to      = to.to_i

      raise_if_called_from_abstract!
    end

    def <=>(event)
      id <=> event.id
    end

    def multiple?
      false
    end

    def notify?
      true
    end

    def destination
      [to_user]
    end

    def before_notify(user)
    end

    def after_notify(user)
      puts "Sent #{self.class.name.split('::').last} to #{user.user_id}"
    end

    def handle!
      raise_if_called_from_abstract!

      destination.each do |user|
        break unless user

        before_notify(user)

        if notify?
          user.notify!(payload)
        end

        after_notify(user)
      end
    end

    def expand
      if multiple?
        destination.map do |user|
          AtomicEvent.new(self, user.user_id)
        end
      else
        [AtomicEvent.new(self, to)]
      end
    end

    private

    def raise_if_called_from_abstract!
      if self.class.name == "FollowerMaze::Event"
        raise "FollowerMaze::Event is an abstract class."
      end
    end

    def to_user
      @to_user ||= Base.connected_users.find(to)
    end

    def from_user
      @from_user ||= Base.connected_users.find(from)
    end
  end
end

Dir[File.expand_path(File.dirname(__FILE__)) + "/event" + "/*.rb"].each do |f|
  require f
end