module FollowerMaze
  class User
    attr_reader :id, :followers

    def initialize(id, socket = nil)
      @id         = id
      @socket     = socket
      @followers  = []
    end

    def connection
      @connection ||= begin
        Connection.new(@socket, self) if @socket
      end
    end

    def notify(data)
      connection.write data if connection
    end

    def add_follower(user_id)
      @followers << user_id
    end

    def remove_follower(user_id)
      @followers.delete(user_id)
    end
  end
end