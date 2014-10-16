module FollowerMaze
  class User
    attr_reader :id, :followers

    def initialize(id, attrs = {})
      @id         = id.to_i
      @followers  = []
      @connection = create_connection(attrs)
    end

    def notify(data)
      @connection.write data if @connection
    end

    def add_follower(user_id)
      @followers << user_id.to_i
    end

    def remove_follower(user_id)
      @followers.delete(user_id.to_i)
    end

    private

    def create_connection(attrs)
      Connection.new(attrs[:socket], self) if attrs[:socket]
    end
  end
end