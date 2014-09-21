module FollowerMaze
  class Base
    class << self
      def events_buffer
        @events_buffer ||= FollowerMaze::EventsBuffer.new
      end

      def connected_users
        @connected_users ||= FollowerMaze::UserConnectionPool.new
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
      trap(:INT) do
        puts "\nBye!"
        exit 
      end

      @listeners.map do |l|
        Thread.new { l.listen } # threading hell?
      end.map(&:join)
    end
  end
end