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
      @listeners = [].tap do |l|
        l << EventSourceListener.new(port: EVENT_SOURCE_PORT)
        l << ClientsListener.new(port: CLIENTS_PORT)
      end
    end

    def run!
      trap(:INT) { exit }
      @listeners.map &:listen

      loop do
        # run server
      end
    end
  end
end