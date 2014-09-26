module FollowerMaze
  module Util
    class Server
      def initialize(options = {}) 
        @port   = options[:port] || '3000'
        @host   = options[:host] || '0.0.0.0'
      end

      def listen
        raise "Not implemented"
      end

      def socket
        @socket ||= TCPServer.new(@host, @port).tap do |s|
          s.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
        end
      end

      def close
        @socket.close
      end
    end
  end
end