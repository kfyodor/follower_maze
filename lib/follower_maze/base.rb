module FollowerMaze
  class Base
    @@connections = User::ConnectionPool.new

    class << self
      def connections; @@connections; end
    end

    def initialize
      @listeners = [].tap do |l|
        l << ClientsListener.new
        l << EventSourceListener.new
      end
    end

    def run!
      trap(:INT) { do_exit }

      $logger.info "====> Starting server"

      @running = @listeners.map do |l|
        Thread.new { l.listen }
      end.tap {|r| r.map(&:join) }
    end

    private

    def do_exit
      $logger.info "Shutting down..."
      
      self.class.connections.disconect_all!

      @listeners.map(&:close)
      @running.map &:kill
    rescue IOError
    ensure
      $logger.info "\\o/ Bye! \\o/"
      exit
    end
  end
end