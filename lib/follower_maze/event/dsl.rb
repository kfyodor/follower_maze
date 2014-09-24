module FollowerMaze
  class Event
    module DSL
      def self.included(base)
        base.class_eval do
          class << self
            attr_reader :before_notification_callbacks,
                        :deliver_to,
                        :do_notify

            def init
              @before_notification_callbacks = []
              @deliver_to = nil
              @do_notify = true
            end

            def before_notification(&block)
              @before_notification_callbacks << block
            end

            def deliver_notifications_to(&block)
              @deliver_to = block
            end

            def notify(bool)
              @do_notify = bool
            end
          end

          def notify?
            self.class.do_notify
          end

          def deliver_to
            (self.class.deliver_to && self.class.deliver_to.call(self)) ||
            (defined?(default_destination) && default_destination) ||
            []
          end

          def run_before_notification_callbacks(to_user)
            self.class.before_notification_callbacks.each do |callback|
              callback.call(to_user, self)
            end
          end
        end
        base.init
      end
    end
  end
end