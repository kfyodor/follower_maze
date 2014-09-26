module FollowerMaze
  module Util
    module Server
      attr_reader :host, :port

      def listen
        raise "Not implemented"
      end

      def socket
        @socket ||= TCPServer.new(host, port).tap do |s|
          s.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
        end
      end

      def close
        @socket.close
      end
    end
  end
end