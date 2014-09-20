require 'forwardable'

module FollowerMaze
  class UserConnectionPool
    extend Forwardable

    def_delegators :@connections, :keys, :size, :values, :[]

    def initialize
      @mutex = Mutex.new
      @connections = {}
    end

    def each
      values.each
    end

    def <<(connection)
      @mutex.synchronize do
       @connections[connection.user_id] = connection
      end
    end

    def find_many(ids)
      @connections.select do |k, v|
        ids.include? k
      end.values
    end

    def close
      @mutex.synchronize do
        @connections.values.map &:disconnect
        @connections = {}
      end
    end

    alias_method :find, :[]
  end
end