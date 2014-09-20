module FollowerMaze
  class Event
    attr_reader :id, :type, :to, :from

    @@types = {}

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

      if self.class.name == "FollowerMaze::Event"
        raise "FollowerMaze::Event is an abstract class."
      end
    end

    def <=>(event)
      id <=> event.id
    end

    def handle!
      raise "`handle!` is not implemented."
    end

    private

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