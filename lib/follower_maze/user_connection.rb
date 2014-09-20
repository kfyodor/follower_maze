module FollowerMaze
  class UserConnection
    attr_reader :user_id, :followers

    def initialize(socket, user_id)
      @mutex     = Mutex.new
      @socket    = socket
      @user_id   = user_id.to_i
      @followers = []
    end

    def disconnect
      @socket.close
    end

    def notify(data)
      @mutex.synchronize do
        @socket.puts(data)
      end
    end

    def add_follower(user_id)
      @mutex.synchronize do
        @followers << user_id
      end
    end

    def remove_follower(user_id)
      @mutex.synchronize do
        @followers.delete(user_id)
      end
    end
  end
end