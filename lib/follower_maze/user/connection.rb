module FollowerMaze
  class User
    class Connection
      attr_reader :user_id, :user

      def initialize(socket, user_id)
        @socket  = socket
        @user_id = user_id
        @user    = User.new(user_id)
      end

      def disconnect
        @socket.close
      end

      def write(data)
        @socket.write_nonblock("#{data}\r\n")
      rescue Errno::EPIPE => e
        raise
      end
    end
  end
end