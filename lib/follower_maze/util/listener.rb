module FollowerMaze
  module Util
    class Listener
      def initialize(options = {}) 
        @port   = options[:port] || '3000'
        @host   = options[:host] || '0.0.0.0'
        @mutex  = Mutex.new
        @socket = TCPServer.new(@host, @port).tap do |s|
          s.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
        end
      end

      def listen
        raise "Not implemented"
      end
    end
  end
end