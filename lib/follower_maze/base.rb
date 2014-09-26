require 'ruby-mass'

module FollowerMaze
  class Base
    @@connections = User::ConnectionPool.new

    class << self
      def connections; @@connections; end

      def logger
        @logger ||= Util::Logger.new
      end
    end

    def initialize
      @listeners = [].tap do |l|
        l << ClientsListener.new(port: CLIENTS_PORT)
        l << EventSourceListener.new(port: EVENT_SOURCE_PORT)
      end
    end

    def run!
      trap(:INT) { do_exit }

      Base.logger.info "====> Starting server"

      @running = @listeners.map do |l|
        Thread.new { l.listen }
      end.tap {|r| r.map(&:join) }
    end

    private

    def do_exit
      Base.logger.info "Shutting down..."
      
      self.class.connections.disconect_all!

      @listeners.map(&:close)
      @running.map &:kill
    rescue IOError
    ensure
      Base.logger.info "\\o/ Bye! \\o/"
      exit
    end
  end
end