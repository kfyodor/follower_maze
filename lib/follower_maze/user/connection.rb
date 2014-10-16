module FollowerMaze
  class User
    class Connection
      def initialize(socket, user)
        @socket  = socket
        @user    = user
      end

      def disconnect
        @socket.close
      end

      def write(data)
        @socket.write("#{data}\r\n")
      rescue Errno::EPIPE, IOError => e
        $logger.error "Error while writing #{data} to user #{@user.id}"
      end
    end
  end
end