module FollowerMaze
  class User
    class Connection
      attr_reader :user_id, :user

      def initialize(socket, user_id)
        @socket  = socket
        @user_id = user_id
        @user    = User.new(user_id, connection: self)
      end

      def disconnect
        @socket.close
      end

      def write(data)
        @socket.write("#{data}\r\n")
      rescue Errno::EPIPE, IOError => e
        Base.logger.error "Error while writing #{data} to user #{@user.id}"
      end
    end
  end
end