module FollowerMaze
  module Util
    class Heap
      # data structure to keep order of events

      def initialize
        @mutex = Mutex.new
      end

      def heapify
      end

      def push
        @mutex.synchronize do
        end
      end

      def pop
        @mutex.synchronize do
        end
      end
    end
  end
end