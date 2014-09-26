# encoding: utf-8

module FollowerMaze
  class Event
    class AbstractClassError < Exception; end

    include java.lang.Comparable

    attr_reader :id, :type, :to, :from, :payload

    @@types = {}

    class << self
      def inherited(klass)
        klass_name = klass.name
        type_id    = klass_name.split('::').last[0]

        @@types[type_id] = klass
      end

      def from_payload(payload)
        id, type, from, to = payload.split('|')
        @@types[type].new(payload, id, type, from, to)
      end

      def types
        @@types
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

    def from_user
      @from_user ||= User.find_or_create(from) if from
    end

    def to_user
      @to_user ||= User.find_or_create(to) if to
    end

    def compareTo(event)
      self.id <=> event.id
    end

    def deliver_to
      to_user
    end

    def build_notifications &block
      case d = deliver_to
      when User
        block.call Notification.new(self, d)
      else
        d.map do |user|
          block.call Notification.new(self, user)
        end
      end
    end

    def has_side_effects?
      defined?(before_callback)
    end

    def notify?
      true
    end

    private

    def types
      self.class.class_variable_get(:@@types)
    end

    def raise_if_called_from_abstract!
      unless types.values.include?(self.class)
        raise AbstractClassError
      end
    end
  end
end

Dir[File.expand_path(File.dirname(__FILE__)) + "/event/types" + "/*.rb"].each do |f|
  require f
end