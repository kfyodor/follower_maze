# encoding: utf-8

module FollowerMaze
  class Event
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
    end

    def compareTo(event)
      self.id <=> event.id
    end

    def initialize(payload, id, type, from, to)
      @payload = payload
      @id      = id.to_i
      @type    = type
      @from    = from.to_i
      @to      = to.to_i

      raise_if_called_from_abstract!
    end

    def notify?
      true
    end

    def destination
      default_destination
    end

    def before_notify(user)
    end

    def after_notify(user)
      Base.logger.debug "Sent #{self.class.name.split('::').last} to #{user.id}"
    end

    def build_notifications
      destination.map do |user|
        before_notify(user)
        Notification.new(self, user.id)
      end
    end

    def to_user
      User.find_or_create(@to) if @to
    end

    def from_user
      User.find_or_create(@from) if @from
    end

    private

    def default_destination
      to_user
    end

    def types
      self.class.class_variable_get(:@@types)
    end

    def raise_if_called_from_abstract!
      unless types.values.include?(self.class)
        raise "FollowerMaze::Event is an abstract class."
      end
    end
  end
end

Dir[File.expand_path(File.dirname(__FILE__)) + "/event" + "/*.rb"].each do |f|
  require f
end