require 'ruby-mass'

module FollowerMaze
  class Base
    @@connections = FollowerMaze::ClientConnectionsPool.new

    class << self
      def connections
        @@connections
      end

      def logger
        @logger ||= Util::Logger.new
      end
    end

    def initialize(options = {})
      @options = options
      @listeners = [].tap do |l|
        l << ClientsListener.new(port: CLIENTS_PORT)
        l << EventSourceListener.new(port: EVENT_SOURCE_PORT)
      end
    end

    def run!
      trap(:INT) { do_exit }

      (@threads = @listeners.map do |l|
        Thread.new { l.listen }
      end).map(&:join)
    end

    private

    def do_exit
      Base.logger.info "Shutting down..."
      self.class.connections.disconect_all!
      @listeners.each { |l| l.socket.close }
      @threads.map &:kill
      Base.logger.info "\n \\o/ Bye! \\o/"
    rescue IOError
    ensure
      exit
    end
  end
end