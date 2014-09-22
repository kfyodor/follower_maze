require 'set'
require 'forwardable'

module FollowerMaze
  module Util
    class SequenceChecker
      extend Forwardable

      attr_reader :first

      def_delegators :@sequence, :size

      def initialize(first = 1, opts = {})
        @sequence = SortedSet.new
        @first = first
        @mutex = Mutex.new
        @identity_method = opts[:identity_method] || :id
      end

      def <<(item)
        @mutex.synchronize do
          @sequence << item
        end
      end

      def next
        raise "Sequence is not complete." unless complete?
        self.class.new(max_id + 1)
      end

      def complete?
        (max_id - min_id == size - 1) && (min_id == first)
      end

      def max_id
        @sequence.max.send @identity_method
      end

      def min_id
        @sequence.min.send @identity_method
      end

      def data
        @sequence
      end

      private

      # def identity
      #   tap
      # end
    end
  end
end