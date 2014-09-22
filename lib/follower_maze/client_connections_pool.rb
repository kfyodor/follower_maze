require 'forwardable'

module FollowerMaze
  class ClientConnectionsPool
    extend Forwardable

    def_delegators :@connections, :keys, :size, :values, :[]

    def initialize
      @connections = {}
    end

    def each &block
      values.each &block
    end

    def map &block
      values.map &block
    end

    def <<(connection)
      $mutex.synchronize do
        @connections[connection.user_id] = connection
      end
    end

    def find_by_user_id(user_id)
      @connections[user_id]
    end

    def disconect_all!
      @connections.values.map &:disconnect
      @connections = {}
    end
  end
end