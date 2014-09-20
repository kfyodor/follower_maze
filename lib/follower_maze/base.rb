module FollowerMaze
  class Base
    class << self
      def connected_users
        @connected_users ||= FollowerMaze::UserConnectionPool.new
      end
    end

    def initialize
      trap(:INT) { exit }
      @event_source_listener = EventSourceListener.new.listen
      @clients_listener      = ClientsListener.new.listen
    end

    def connected_clients
      @clients_listener.connected_clients
    end

    def run
      loop {}
    end
  end
end