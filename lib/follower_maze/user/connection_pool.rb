require 'forwardable'

module FollowerMaze
  class User
    class ConnectionPool
      extend Forwardable

      def_delegators :@connections, :keys, :size, :values, :[]

      def initialize
        @connections = {}
      end

      def <<(connection)
        @connections[connection.user_id] = connection
      end

      def disconnect_all!
        @connections.values.map &:disconnect
        @connections = {}
      end
    end
  end
end